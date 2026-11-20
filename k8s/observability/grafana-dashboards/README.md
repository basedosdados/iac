# Dashboards do Grafana, versionados

Cada `.json` nesta pasta é um dashboard do Grafana no mesmo formato que a
própria UI usa pra exportar/importar (Dashboard settings → JSON Model).
`apply.sh` gera e aplica o `ConfigMap` correspondente (label
`grafana_dashboard: "1"`) — o sidecar `grafana-sc-dashboard` (já rodando
junto do `prometheus-grafana`) detecta e carrega automaticamente, sem
precisar reiniciar nenhum pod.

## Atualizar um dashboard existente

1. Edite o dashboard pela UI do Grafana normalmente.
2. Dashboard settings → JSON Model → copie o conteúdo pra cá, substituindo
   o arquivo (remova os campos `id` e `version` antes de salvar — são
   reatribuídos automaticamente).
3. `./apply.sh nome-do-arquivo.json`

## Criar um dashboard novo

Salve o JSON (`uid` fixo e descritivo, evite deixar em branco — vira
aleatório toda vez) nesta pasta e rode `./apply.sh` sem argumento (aplica
todos os `.json` da pasta) ou `./apply.sh novo-arquivo.json`.
