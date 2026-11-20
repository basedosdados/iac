#!/bin/bash
# Gera um ConfigMap (label grafana_dashboard: "1") a partir de cada .json
# nesta pasta e aplica no cluster. O sidecar grafana-sc-dashboard já
# instalado (prometheus-grafana) detecta o ConfigMap e carrega o
# dashboard automaticamente, sem precisar reiniciar o pod do Grafana.
#
# Uso: ./apply.sh [arquivo.json ...]   (sem argumento, aplica todos os .json da pasta)
set -euo pipefail
cd "$(dirname "$0")"

NAMESPACE=observability
FILES=("${@:-*.json}")

for file in "${FILES[@]}"; do
  [ -f "$file" ] || continue
  name="grafana-dashboard-$(basename "$file" .json)"
  echo "Aplicando $file como ConfigMap $name..."
  kubectl create configmap "$name" \
    --from-file="$(basename "$file")=$file" \
    --namespace "$NAMESPACE" \
    --dry-run=client -o yaml \
  | kubectl label --local -f - grafana_dashboard=1 -o yaml \
  | kubectl apply -f -
done
