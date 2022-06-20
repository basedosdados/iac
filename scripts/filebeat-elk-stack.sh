#!/bin/bash -ex

#########
# Setup #
#########

# /k8s/logstash/charts/values.yaml: Changed logStashPipeline
# /k8s/filebeat/charts/values.yaml: Changed filebeatConfig: output
# k8s/kibana/charts/values.yaml: Changed ingress config

# Filebeat
cd $(git rev-parse --show-toplevel)/k8s/filebeat
kubectl apply -f namespace.yaml
kubens kibana
helm install filebat .

# Logstash
cd $(git rev-parse --show-toplevel)/k8s/logstash
kubectl apply -f namespace.yaml
kubens logstash
helm install logstash .

# Elasticsearch
cd $(git rev-parse --show-toplevel)/k8s/elasticsearch
kubectl apply -f namespace.yaml
kubens elasticsearch
helm install elasticsearch .

# Kibana
cd $(git rev-parse --show-toplevel)/k8s/kibana
kubectl apply -f namespace.yaml
kubens kibana
helm install kibana .
