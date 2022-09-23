from functools import partial
import subprocess
from typing import Callable
import base64
import typer

app = typer.Typer()


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


@app.command()
def decode_base64(data: str):
    """
    Decode data from base64
    """
    echo_and_run(f'echo "{data}" | base64 -d')


@app.command()
def encode_base64(data: str):
    """
    Encode data to base64
    """
    echo_and_run(f'echo "{data}" | base64 -w 0')


@app.command()
def double_decode_base64(data):
    """
    Decode data from base64 twice
    """
    echo_and_run(f'echo "{data}" | base64 -d | base64 -d')


@app.command()
def double_encode_base64(data):
    """
    Encode data to base64 twice
    """
    echo_and_run(f'echo "{data}" | base64 | base64')


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
