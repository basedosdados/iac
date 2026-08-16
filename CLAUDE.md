# CLAUDE.md

Infrastructure for Base dos Dados: GCP resources via Terraform, cluster
workloads via Kubernetes manifests and Helm values.

## Layout

| Path | Contents |
|---|---|
| `terraform/` | One directory per GCP module. CI plans it, CD applies it |
| `k8s/` | One directory per namespace or application, plus its manifests |
| `utils/main.py` | Typer CLI for operational chores (sealing secrets, base64, installs) |
| `Makefile` | Aliases for the Terraform container and the secret workflow |
| `.github/workflows/` | Terraform CI/CD and Infracost |

Everything in `k8s/` is applied by hand with `kubectl apply` or `helm upgrade`.
There is no CD pipeline for Kubernetes — the commands live in a comment at the
top of each `chart/values.yaml`.

## One cluster, namespaces as environments

There is a single GKE cluster, `basedosdados-dev` in `us-central1-c`, despite
the name. Production and staging are *namespaces* inside it, not separate
clusters. One consequence matters constantly: there is one sealed-secrets
controller and therefore **one sealing key for every environment**.

Environment naming is not consistent across applications. Check the directory
before assuming:

| Application | Environments |
|---|---|
| `k8s/prefect_workers/` | `basedosdados` (prod), `basedosdados-dev` (dev). **No staging** |
| `k8s/website/django/` | `prod`, `staging`, `development` |
| `k8s/website/nextjs/` | `production`, `staging`, `development` |
| `k8s/website/chatbot/` | `prod`, `staging` |

## Secrets

Secrets are committed, encrypted, as
[SealedSecrets](https://github.com/bitnami-labs/sealed-secrets). The controller
in the cluster holds the private key; the repository holds only ciphertext.
Anyone can seal a value, only the cluster can open it.

### Numbered files are snapshots, not fragments

This trips people up, so read it before editing anything under `k8s/`.

Files are named `<namespace-dir>/secret-NN_sealed.yaml`, numbered from `00`.
Several files in one directory routinely declare the **same** `metadata.name`.
They are not merged. Each is a complete snapshot of that Secret at a point in
time, and the controller keeps whichever was applied last — so **the
highest-numbered file for a given Secret name is the live one**, and the lower
ones are dead history nobody has deleted.

`k8s/website/django/prod/` holds ten sealed files. Nine declare
`api-prod-secrets`, of which only `secret-09_sealed.yaml` is live; the tenth is
an unrelated Secret. Editing `secret-04_sealed.yaml` would change nothing and
look like it should. Run `make lint-secrets` — it prints the live file for
every Secret that has more than one snapshot.

Two ways to change a Secret, both used in the history:

- **Add a key to the live snapshot in place** (`make seal-value`). One line
  changes. This is the smaller, more reviewable diff — prefer it.
- **Seal a whole new snapshot** at the next number. Needs the plaintext of
  every existing key, so it is only worth it when most values are changing.

A genuinely *new* Secret — a different `metadata.name` — takes the next free
number, which is how `vault-credentials` came to sit at `secret-03` alongside
`gcp-credentials`.

### Other conventions

- Keys inside `encryptedData` are sorted alphabetically. Roughly half the
  repository predates this; `make lint-secrets` reports drift as a warning
  rather than an error, so old files are not a standing failure.
- No leading `---`, and no `creationTimestamp`. The `---` is not a style
  preference: `pretty-format-yaml` strips it, so a file committed with one
  comes back modified. The older files under `k8s/prefect_workers/` still have
  theirs only because the hook has not touched them since.
- Plaintext `secret-NN.yaml` is gitignored. Prefer never creating one — the
  commands below stream plaintext through a pipe and never write it to disk.

### Adding a new Secret

```bash
printf 'SOME_API_KEY=abc123\nOTHER_KEY=def456\n' > /tmp/new-keys.env
make seal-secret DIR=k8s/prefect_workers/basedosdados NAME=api-keys ENVFILE=/tmp/new-keys.env
rm /tmp/new-keys.env
```

The namespace is read from the directory's `namespace.yaml`, and the file lands
in the next free `secret-NN` slot. Repeat per environment: each namespace needs
its own file, even when the value is identical, because sealing is scoped to
namespace and Secret name by default.

### Adding or rotating one key

Each value in a SealedSecret is encrypted independently, so a key can be added
or replaced without knowing the plaintext of its neighbours. Point it at the
*live* snapshot:

```bash
printf 'abc123' > /tmp/value && make seal-value \
  FILE=k8s/prefect_workers/basedosdados/secret-04_sealed.yaml \
  NAME=api-keys NAMESPACE=prefect-worker-basedosdados \
  KEY=SOME_API_KEY VALUEFILE=/tmp/value && rm /tmp/value
```

This rewrites one line, which is what a well-scoped secret commit looks like —
see `6be5d07`. `VALUE=` works too but lands in shell history; prefer
`VALUEFILE=`.

### Sealing without cluster access

`kubeseal` needs the controller's public certificate. By default it fetches it
from the current `kubectl` context, which requires a live `gcloud` login. Fetch
it once and the repository can seal offline afterwards:

```bash
make fetch-sealing-cert   # writes k8s/sealed-secrets/pub-cert.pem
```

The certificate is public key material and safe to commit. When
`k8s/sealed-secrets/pub-cert.pem` exists, `seal-secret` and `seal-value` use it
and skip the cluster entirely. Re-fetch it if the controller's key is rotated.

### Applying

Sealing writes a file; it does not deploy. The controller only sees it after:

```bash
kubectl apply -f k8s/prefect_workers/basedosdados/secret-04_sealed.yaml
```

Running pods do not pick up changed Secret values on their own. Restart the
consumer, or let the next flow run pick it up.

## Prefect

`k8s/prefect3/` is the Prefect *server* — API, UI, and its Cloud SQL connection.
It does not run flows.

`k8s/prefect_workers/` holds the two workers that do. Each polls a work pool of
the same name and launches one Kubernetes Job per flow run, in its own
namespace. `basedosdados-dev` runs flows from PR branches without schedules;
`basedosdados` runs scheduled production flows from `main`. The
[pipelines](https://github.com/basedosdados/pipelines) repository targets them
by pool name in `.github/scripts/deploy_flows.py`.

**Flow-run pods do not automatically see the Secrets in their namespace.** The
`envFrom` list lives in the work pool's *base job template*, which is stored in
the Prefect server's database and edited in the UI at
`https://prefect3.basedosdados.org` under Work Pools → *pool* → Edit → Advanced.
A newly sealed Secret is inert until its name is added there, once per pool. Say
so explicitly when handing off a new Secret — the manifest alone is not the
whole change.

Existing Secrets, both workers: `gcp-credentials` (`BASEDOSDADOS_CONFIG`,
`BASEDOSDADOS_CREDENTIALS_PROD`, `BASEDOSDADOS_CREDENTIALS_STAGING`,
`DBT_SERVICE_ACCOUNT`) and `vault-credentials` (`VAULT_ADDRESS`,
`VAULT_TOKEN`). The `_PROD` / `_STAGING` suffix names a BigQuery dataset tier,
not a deployment environment — that distinction has caused confusion before.

`k8s/prefect_workers/basedosdados/` carries both `secret-01` and `secret-02` as
`gcp-credentials`; `secret-02` is the live one.

## Conventions

- Commits follow `type(scope): description`; the history is mostly Portuguese
  for prose and English for the summary line. Either is accepted.
- `pre-commit` reformats YAML to two-space indent and trims whitespace. Run
  `pre-commit run --files <paths>` before committing generated manifests.
- `no-commit-to-branch` blocks direct commits to `main`. Branch, then PR.
- Terraform changes are planned in CI and shown on the PR. Kubernetes manifests
  are reviewed by hand — describe what you applied and when.

## Verification

`make lint-secrets` reads every sealed manifest, decrypting nothing and needing
no cluster. It fails on the mistakes that break a deploy — a missing `template`
stanza, a namespace that disagrees with the directory's `namespace.yaml`, a
`metadata.name` that disagrees with the template's, an empty `encryptedData`.
Style drift (unsorted keys, missing `---`) is reported as a warning; pass
`--strict` to fail on it too. Its `note:` lines name the live snapshot for
every Secret that has more than one.
