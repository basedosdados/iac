from functools import partial
from pathlib import Path
import subprocess
from typing import Callable, Dict, List, Optional
import base64
import typer
import random
import string

app = typer.Typer()

# Certificado público do controlador sealed-secrets. Não é sensível: serve
# apenas para cifrar. Uma vez versionado, `seal-secret` e `seal-value` rodam
# offline, sem acesso ao cluster.
SEALING_CERT = Path("k8s/sealed-secrets/pub-cert.pem")


def command_exists(command: str) -> bool:
    """
    Asserts that the given command exists
    """
    try:
        echo_and_run(f"which {command}", stdout_callback=lambda x: None)
        return True
    except subprocess.CalledProcessError:
        return False


def echo_and_run(command: str, stdout_callback: Callable = partial(print, end='')) -> int:
    """
    Echoes the command and then runs it, sending output to stdout_callback
    """
    print(f"+ {command}")
    popen = subprocess.Popen(
        command, shell=True, stdout=subprocess.PIPE, universal_newlines=True)
    for stdout_line in iter(popen.stdout.readline, ""):
        stdout_callback(stdout_line)
    popen.stdout.close()
    return_code = popen.wait()
    if return_code:
        raise subprocess.CalledProcessError(return_code, command)
    return return_code


def fail(message: str):
    """
    Aborts with an error message
    """
    typer.echo(f"error: {message}", err=True)
    raise typer.Exit(1)


def run_quietly(command: List[str], stdin_data: Optional[str] = None) -> str:
    """
    Runs a command without echoing it, returning stdout. Used wherever the
    command or its input carries secret material, so nothing leaks to the
    terminal or to shell history.
    """
    result = subprocess.run(
        command, input=stdin_data, capture_output=True, text=True)
    if result.returncode:
        fail(f"{command[0]} failed: {result.stderr.strip()}")
    return result.stdout


def kubeseal_flags(controller_name: str, controller_namespace: str) -> List[str]:
    """
    Builds the flags that tell kubeseal which public key to encrypt with.
    Prefers the versioned certificate (offline); falls back to fetching it
    from the controller in the current kubectl context.
    """
    if SEALING_CERT.exists():
        return ["--cert", str(SEALING_CERT)]
    return [
        "--controller-name", controller_name,
        "--controller-namespace", controller_namespace,
    ]


def collect_values(from_literal: Optional[List[str]],
                   from_env_file: Optional[str]) -> Dict[str, str]:
    """
    Gathers KEY=VALUE pairs from an env file and/or repeated --from-literal
    flags. The env file is preferred: values passed on the command line end up
    in shell history.
    """
    values: Dict[str, str] = {}
    sources = []
    if from_env_file:
        path = Path(from_env_file)
        if not path.is_file():
            fail(f"env file not found: {from_env_file}")
        sources = [
            line.strip() for line in path.read_text().splitlines()
            if line.strip() and not line.strip().startswith("#")
        ]
    sources += list(from_literal or [])
    for entry in sources:
        key, separator, value = entry.partition("=")
        if not separator:
            fail(f"expected KEY=VALUE, got: {key}")
        values[key.strip()] = value.strip().strip('"').strip("'")
    if not values:
        fail("no values given -- use --from-env-file or --from-literal")
    return values


def namespace_of(directory: Path) -> str:
    """
    Reads the namespace from the namespace.yaml sitting next to the secrets,
    so the namespace never has to be retyped (and so it cannot drift).
    """
    manifest = directory / "namespace.yaml"
    if not manifest.is_file():
        fail(f"no namespace.yaml in {directory} -- pass --namespace explicitly")
    for line in manifest.read_text().splitlines():
        if line.strip().startswith("name:"):
            return line.split(":", 1)[1].strip()
    fail(f"could not read metadata.name from {manifest}")


def next_index(directory: Path) -> str:
    """
    Returns the slot after the highest one in use. Deliberately not the lowest
    free slot: a higher number means a newer snapshot, and several directories
    start at 01, so filling a gap at 00 would read as the oldest file.
    """
    used = {
        int(path.name[len("secret-"):][:2])
        for path in directory.glob("secret-[0-9][0-9]_sealed.yaml")
    }
    return f"{(max(used) + 1) if used else 0:02d}"


def secret_manifest(name: str, namespace: str, values: Dict[str, str]) -> str:
    """
    Renders a plain Secret manifest, base64-encoding each value. Kept in memory
    and piped straight into kubeseal -- the plaintext never touches disk.
    """
    lines = [
        "apiVersion: v1",
        "kind: Secret",
        "metadata:",
        f"  name: {name}",
        f"  namespace: {namespace}",
        "type: Opaque",
        "data:",
    ]
    for key in sorted(values):
        lines.append(f"  {key}: {base64.b64encode(values[key].encode()).decode()}")
    return "\n".join(lines) + "\n"


def tidy(sealed: str) -> str:
    """
    Normalizes kubeseal output to the convention used across k8s/: a leading
    document marker and no null creationTimestamp noise.
    """
    kept = [
        line for line in sealed.splitlines()
        if line.strip() != "creationTimestamp: null"
    ]
    if not kept or kept[0].strip() != "---":
        kept.insert(0, "---")
    return "\n".join(kept) + "\n"


def splice_key(path: Path, key: str, encrypted: str):
    """
    Inserts (or replaces) a single key inside an existing SealedSecret's
    encryptedData block, keeping the keys in alphabetical order. Every value in
    a SealedSecret is encrypted independently, so one key can be added without
    knowing the plaintext of its neighbours.
    """
    lines = path.read_text().splitlines()
    starts = [i for i, line in enumerate(lines) if line.rstrip() == "  encryptedData:"]
    if not starts:
        fail(f"no encryptedData block in {path}")
    start = starts[0]
    end = start + 1
    while end < len(lines) and lines[end].startswith("    "):
        end += 1
    block = [line for line in lines[start + 1:end]
             if not line.startswith(f"    {key}:")]
    block.append(f"    {key}: {encrypted}")
    block.sort(key=lambda line: line.split(":", 1)[0].strip())
    path.write_text("\n".join(lines[:start + 1] + block + lines[end:]) + "\n")


@app.command()
def fetch_sealing_cert(
    controller_name: str = "sealed-secrets-controller",
    controller_namespace: str = "kube-system",
    output: str = str(SEALING_CERT),
):
    """
    Fetches the sealed-secrets public certificate from the cluster and writes it
    to disk. Requires cluster access, but only once: the certificate is public
    and versioned, so subsequent sealing runs offline.
    """
    if not command_exists("kubeseal"):
        fail("kubeseal not found -- install it with `brew install kubeseal`")
    certificate = run_quietly([
        "kubeseal", "--fetch-cert",
        "--controller-name", controller_name,
        "--controller-namespace", controller_namespace,
    ])
    destination = Path(output)
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text(certificate)
    typer.echo(f"wrote {destination}")


@app.command()
def seal_secret(
    directory: str = typer.Option(..., "--directory", "-d",
                                  help="Namespace directory under k8s/"),
    name: str = typer.Option(..., "--name", "-n",
                             help="metadata.name of the Secret"),
    namespace: str = typer.Option(None, help="Defaults to the directory's namespace.yaml"),
    from_env_file: str = typer.Option(None, help="File of KEY=VALUE lines"),
    from_literal: List[str] = typer.Option(None, help="KEY=VALUE, repeatable"),
    index: str = typer.Option(None, help="Two-digit slot; defaults to the next free one"),
    controller_name: str = "sealed-secrets-controller",
    controller_namespace: str = "kube-system",
):
    """
    Creates a new SealedSecret at <directory>/secret-NN_sealed.yaml
    """
    if not command_exists("kubeseal"):
        fail("kubeseal not found -- install it with `brew install kubeseal`")
    target = Path(directory)
    if not target.is_dir():
        fail(f"not a directory: {directory}")
    namespace = namespace or namespace_of(target)
    values = collect_values(from_literal, from_env_file)
    sealed = run_quietly(
        ["kubeseal", "--format", "yaml"] + kubeseal_flags(controller_name, controller_namespace),
        stdin_data=secret_manifest(name, namespace, values),
    )
    destination = target / f"secret-{index or next_index(target)}_sealed.yaml"
    destination.write_text(tidy(sealed))
    typer.echo(f"wrote {destination} ({', '.join(sorted(values))} -> {namespace}/{name})")


@app.command()
def seal_value(
    name: str = typer.Option(..., "--name", "-n", help="metadata.name of the Secret"),
    namespace: str = typer.Option(..., "--namespace", help="Namespace of the Secret"),
    key: str = typer.Option(..., "--key", "-k", help="Key to add or replace"),
    value: str = typer.Option(None, help="Value; omit to read from --value-file"),
    value_file: str = typer.Option(None, help="File whose contents are the value"),
    into: str = typer.Option(None, help="SealedSecret file to splice the key into"),
    controller_name: str = "sealed-secrets-controller",
    controller_namespace: str = "kube-system",
):
    """
    Seals a single value. Adds or replaces one key in an existing SealedSecret
    without needing the plaintext of the other keys.
    """
    if not command_exists("kubeseal"):
        fail("kubeseal not found -- install it with `brew install kubeseal`")
    if (value is None) == (value_file is None):
        fail("pass exactly one of --value or --value-file")
    plaintext = value if value is not None else Path(value_file).read_text()
    encrypted = run_quietly(
        ["kubeseal", "--raw", "--name", name, "--namespace", namespace,
         "--from-file", "/dev/stdin"]
        + kubeseal_flags(controller_name, controller_namespace),
        stdin_data=plaintext,
    ).strip()
    if not into:
        typer.echo(encrypted)
        return
    destination = Path(into)
    if not destination.is_file():
        fail(f"not a file: {into}")
    splice_key(destination, key, encrypted)
    typer.echo(f"set {key} in {destination}")


def read_sealed(path: Path) -> Dict[str, object]:
    """
    Pulls the fields worth checking out of a sealed manifest, without a YAML
    parser: the Secret's name, the namespaces it mentions, and its key list.
    """
    lines = path.read_text().splitlines()
    names = [line.split(":", 1)[1].strip() for line in lines
             if line.strip().startswith("name:")]
    namespaces = {line.split(":", 1)[1].strip() for line in lines
                  if line.strip().startswith("namespace:")}
    keys: List[str] = []
    starts = [i for i, line in enumerate(lines) if line.rstrip() == "  encryptedData:"]
    if starts:
        cursor = starts[0] + 1
        while cursor < len(lines) and lines[cursor].startswith("    "):
            keys.append(lines[cursor].split(":", 1)[0].strip())
            cursor += 1
    return {
        "name": names[0] if names else None,
        "names": names,
        "namespaces": namespaces,
        "keys": keys,
        "has_template": any(line.strip() == "template:" for line in lines),
        "leads_with_marker": bool(lines) and lines[0].strip() == "---",
        "index": int(path.name[len("secret-"):][:2]),
    }


@app.command()
def lint_secrets(root: str = "k8s", strict: bool = False):
    """
    Checks sealed manifests for the mistakes that actually break a deploy, and
    reports which snapshot is live where a Secret has several. Decrypts nothing
    and needs no cluster access. --strict also fails on style drift.
    """
    errors: List[str] = []
    warnings: List[str] = []
    notes: List[str] = []
    directories: Dict[Path, List[Path]] = {}
    for path in sorted(Path(root).rglob("secret-[0-9][0-9]_sealed.yaml")):
        directories.setdefault(path.parent, []).append(path)

    for directory, paths in sorted(directories.items()):
        declared = None
        namespace_manifest = directory / "namespace.yaml"
        if namespace_manifest.is_file():
            for line in namespace_manifest.read_text().splitlines():
                if line.strip().startswith("name:"):
                    declared = line.split(":", 1)[1].strip()
                    break

        snapshots: Dict[str, List[Path]] = {}
        for path in paths:
            manifest = read_sealed(path)

            if not manifest["keys"]:
                errors.append(f"{path}: no encryptedData block, or it is empty")
            if not manifest["has_template"]:
                errors.append(
                    f"{path}: missing template stanza -- the created Secret "
                    f"would lose its name and type")
            if len(set(manifest["names"])) > 1:
                errors.append(
                    f"{path}: metadata.name and template name disagree "
                    f"-- {sorted(set(manifest['names']))}")
            if declared and manifest["namespaces"] - {declared}:
                errors.append(
                    f"{path}: targets namespace "
                    f"{sorted(manifest['namespaces'] - {declared})}, but "
                    f"namespace.yaml declares {declared}")

            if manifest["keys"] != sorted(manifest["keys"]):
                warnings.append(f"{path}: encryptedData keys are not sorted")
            if not manifest["leads_with_marker"]:
                warnings.append(f"{path}: does not start with '---'")

            if manifest["name"]:
                snapshots.setdefault(manifest["name"], []).append(path)

        # Several files may declare one Secret. They are successive snapshots,
        # not a merge: the controller keeps whichever was applied last, so the
        # highest-numbered file is the live one and the rest are history.
        for name, versions in sorted(snapshots.items()):
            if len(versions) > 1:
                live = max(versions, key=lambda path: read_sealed(path)["index"])
                superseded = ", ".join(
                    path.name for path in sorted(versions) if path != live)
                notes.append(
                    f"{directory}: {name} -- live is {live.name}; "
                    f"superseded: {superseded}")

    total = sum(len(paths) for paths in directories.values())
    for note in notes:
        typer.echo(f"note: {note}")
    for warning in warnings:
        typer.echo(f"warning: {warning}", err=True)
    for error in errors:
        typer.echo(f"error: {error}", err=True)

    if errors:
        fail(f"{len(errors)} error(s) across {total} manifests")
    if warnings and strict:
        fail(f"{len(warnings)} style warning(s) across {total} manifests")
    typer.echo(
        f"ok -- {total} manifests in {len(directories)} directories, "
        f"{len(warnings)} style warning(s)")


@app.command()
def decode_base64(data: str):
    """
    Decode data from base64
    """
    return typer.echo(base64.b64decode(data.encode()).decode())


@app.command()
def encode_base64(data: str):
    """
    Encode data to base64
    """
    return typer.echo(base64.b64encode(data.encode()).decode())


@app.command()
def double_decode_base64(data):
    """
    Decode data from base64 twice
    """
    return typer.echo(base64.b64decode(base64.b64decode(data.encode())).decode())


@app.command()
def double_encode_base64(data):
    """
    Encode data to base64 twice
    """
    return typer.echo(base64.b64encode(base64.b64encode(data.encode())).decode())


@app.command()
def get_random_value(length: int):
    """
    Get a random value of the given length
    """
    characters = string.ascii_letters + string.digits + string.punctuation
    return typer.echo("".join(random.choice(characters) for _ in range(length)))


@app.command()
def setup_traefik():
    """
    Installs Traefik
    """
    echo_and_run(
        f"helm install traefik traefik/traefik --namespace traefik --create-namespace")
    echo_and_run("kubectl get service -n traefik")


@app.command()
def setup_nginx(address: str):
    """
    Install NGINX Ingress Controller
    """
    echo_and_run(
        f"helm upgrade --install nginx-ingress ingress-nginx/ingress-nginx --namespace nginx --set controller.service.loadBalancerIP={address} --create-namespace"
    )


@app.command()
def setup_certmanager(version: str = "1.4.0"):
    """
    Installs cert-manager
    """
    echo_and_run("kubectl create namespace cert-manager")
    echo_and_run(
        f"kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v{version}/cert-manager.crds.yaml")
    echo_and_run(f"""helm install \
        cert-manager jetstack/cert-manager \
        --namespace cert-manager \
        --create-namespace \
        --version v{version}
    """)
    echo_and_run("kubectl get pods --namespace cert-manager")


@app.command()
def setup_sql_proxy():
    """
    Sets Cloud SQL proxy
    """
    echo_and_run("kubectl create ns cloud-sql-proxy")
    echo_and_run("kubectl apply -n cloud-sql-proxy -f k8s/cloud_sql_proxy/")
    echo_and_run("kubectl get pods --namespace cloud-sql-proxy")


@app.command()
def setup_prefect():
    """
    Sets Prefect
    """
    echo_and_run("kubectl create ns prefect")
    echo_and_run("kubectl label namespace prefect istio-injection=enabled")
    echo_and_run("kubectl apply -n prefect -f prefect/")
    echo_and_run("kubectl get pods --namespace prefect")


if __name__ == "__main__":
    app()
