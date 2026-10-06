# Imagem do prefect-server com SQLAlchemy fixado abaixo de 2.1.
#
# SQLAlchemy 2.1.0 (lançado 2026-09-24) quebra o scheduler do Prefect: bulk
# insert de flow runs falha com "Can't evaluate bulk DML statement; please
# supply a bulk_dml decorated function" (PrefectHQ/prefect#23199). Nenhuma
# release estável do Prefect tem o fix ainda (PrefectHQ/prefect#23200/#23201,
# PRs abertos). Downgrade de versão do Prefect não é seguro aqui — o banco já
# foi migrado pelo Alembic pro schema da 3.8.7.
#
# EXTRA_PIP_PACKAGES em runtime não funciona (container roda com filesystem
# somente leitura, falha ao remover o pacote antigo) — por isso o pip install
# acontece aqui, em build-time, onde o filesystem é gravável.
#
# Build e push (requer permissão de escrita no Artifact Registry do projeto
# basedosdados-dev — a service account do Terraform tem):
#   docker build -t gcr.io/basedosdados-dev/prefect-server-sqlalchemy-fix:3.8.7-sqlalchemy2.0 .
#   docker push gcr.io/basedosdados-dev/prefect-server-sqlalchemy-fix:3.8.7-sqlalchemy2.0
#
# Reavaliar (voltar pra prefecthq/prefect oficial, remover esta imagem) quando
# alguma versão >= 3.8.8 estável do Prefect sair com o fix mergeado.
FROM prefecthq/prefect:3.8.7-python3.12

RUN pip install --no-cache-dir "sqlalchemy<2.1"
