---
name: add-secret
description: Add, rotate, or remove an environment variable or secret in a Kubernetes namespace in this repo — sealing it with kubeseal into a committed SealedSecret. Use whenever asked to add an API key, credential, token, password, or env var to prod, staging, or dev, for the pipelines/Prefect workers, the Django backend, the Next.js site, or the chatbot.
---

# Adding a secret

Values are committed encrypted as SealedSecrets. Sealing is one command; the
work is in choosing the right namespaces and knowing what else has to change.
Read `CLAUDE.md` at the repository root first — it carries the conventions this
skill assumes.

## 1. Resolve the target namespaces

Never guess from the words "prod" or "dev". Environment naming differs per
application, and not every application has all three:

| Application | Directories under `k8s/` |
|---|---|
| Prefect flows / pipelines | `prefect_workers/basedosdados` (prod), `prefect_workers/basedosdados-dev` (dev). **No staging exists** |
| Django backend | `website/django/{prod,staging,development}` |
| Next.js site | `website/nextjs/{production,staging,development}` |
| Chatbot | `website/chatbot/{prod,staging}` |

If the request names an environment the application does not have, say so and
ask before inventing one — a new environment means a new namespace, Helm
release, and (for Prefect) a new work pool, not just a secret.

Confirm which Secret the value belongs in. `make lint-secrets` prints, for every
Secret with more than one snapshot, which file is live. Existing Secrets in the
Prefect worker namespaces are `gcp-credentials` and `vault-credentials`.

## 2. Check you can seal

```bash
test -f .sealed-secrets-cert.pem && echo "cached cert, no cluster needed"
kubectl get ns >/dev/null 2>&1 && echo "cluster reachable"
```

One of those must succeed. If neither does, stop and ask the user to run
`gcloud auth login` — it cannot be done non-interactively.

Sealing deliberately requires cluster access. Never commit
`.sealed-secrets-cert.pem` (it is gitignored), never add a CI job that seals,
and do not suggest either as a convenience: this repository is public and a
SealedSecret diff is unreviewable, so requiring cluster access is what keeps
secret authorship limited to people already trusted to apply one. `make
fetch-sealing-cert` caches it locally, which is fine — fetching still needs
cluster access.

## 3. Seal

Write the values to a file outside the repository so they never reach shell
history or a tracked path, and delete it afterwards.

**A new Secret** (a `metadata.name` not yet in that directory):

```bash
printf 'FRED_API_KEY=...\nBEA_API_KEY=...\n' > /tmp/keys.env
make seal-secret DIR=k8s/prefect_workers/basedosdados NAME=api-keys ENVFILE=/tmp/keys.env
make seal-secret DIR=k8s/prefect_workers/basedosdados-dev NAME=api-keys ENVFILE=/tmp/keys.env
rm /tmp/keys.env
```

Repeat per namespace. Sealing is scoped to namespace and Secret name, so one
namespace's file will not decrypt in another — this is not duplication that can
be factored out.

**A key added to a Secret that already exists** — target the live snapshot:

```bash
printf '...' > /tmp/value
make seal-value FILE=k8s/prefect_workers/basedosdados/secret-04_sealed.yaml \
  NAME=api-keys NAMESPACE=prefect-worker-basedosdados \
  KEY=FRED_API_KEY VALUEFILE=/tmp/value
rm /tmp/value
```

## 4. Verify

```bash
make lint-secrets
pre-commit run --files k8s/<paths you touched>
git diff --stat
```

The diff should touch only the intended files. Confirm the new key appears in
`encryptedData` and that the ciphertext of untouched keys did not change.

Never print a plaintext secret value back to the user, and never write one to a
tracked file. If a value was pasted into the conversation, do not echo it in
your summary.

## 5. Say what remains

Sealing writes files. It does not deploy, and for Prefect it is not even the
whole change. Hand back an explicit list:

1. **Apply** — `kubectl apply -f <each sealed file>`. Until then the controller
   has not seen it.
2. **Wire it up, for a new Secret name in a Prefect worker namespace** — flow-run
   pods only receive Secrets listed in the work pool's *base job template*,
   which lives in the Prefect server database, not this repository. Add
   `envFrom: - secretRef: name: <secret>` at
   `https://prefect3.basedosdados.org` → Work Pools → *pool* → Edit → Advanced,
   once per pool. A new Secret is inert until this is done. Adding a key to a
   Secret already listed there needs nothing.
3. **Restart** — running pods do not pick up changed Secret values. For Prefect,
   the next flow run gets them; other workloads need a rollout restart.
4. **Branch and PR** — `no-commit-to-branch` blocks committing to `main`
   directly. Kubernetes manifests are reviewed by hand, so the PR body should
   say which namespaces are affected and what still needs applying.
