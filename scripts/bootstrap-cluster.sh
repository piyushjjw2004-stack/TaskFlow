#!/usr/bin/env bash
set -euo pipefail

# Install the cluster-level dependencies required by the capstone.
# Run after kubeconfig is configured and Helm is installed.

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace --wait

helm upgrade --install metrics-server metrics-server/metrics-server \
  --namespace kube-system --set args={--kubelet-insecure-tls} --wait

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  --values monitoring/kube-prometheus-stack-values.yaml \
  --wait

kubectl -n monitoring create configmap taskflow-dashboard \
  --from-file=taskflow-dashboard.json=monitoring/grafana/dashboards/taskflow-dashboard.json \
  --dry-run=client -o yaml | kubectl label --local -f - grafana_dashboard=1 -o yaml | kubectl apply -f -

if kubectl get crd servicemonitors.monitoring.coreos.com >/dev/null 2>&1; then
  kubectl apply -k kubernetes/monitoring
fi

echo "Cluster addons installed: ingress-nginx, metrics-server, kube-prometheus-stack"
