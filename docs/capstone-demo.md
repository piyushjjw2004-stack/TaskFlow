# Capstone Live Demonstration

Use this sequence to prove that the project is an integrated DevOps system rather than a collection of YAML files.

## 1. Delivery

1. Change one backend line and create a pull request.
2. Show CI: tests, frontend checks, Docker build and Terraform/Helm/Kustomize validation.
3. Merge to `main`.
4. Show Trivy blocking a deliberately vulnerable image in a safe branch/test, if available.
5. Show CD publishing the Git SHA image to ECR.
6. Show Helm deploying the same SHA to EKS.

## 2. Runtime verification

```bash
kubectl get pods -n taskflow
kubectl get svc -n taskflow
kubectl get ingress -n taskflow
kubectl get hpa -n taskflow
kubectl get pvc -n taskflow
```

Then verify:

```bash
curl http://taskflow.local/api/health
curl http://taskflow.local/api/ready
curl http://taskflow.local/api/metrics
```

## 3. Scaling demonstration

```bash
python scripts/load-test.py
kubectl get hpa -n taskflow -w
kubectl top pods -n taskflow
```

The backend should scale within the configured min/max range when the generated load crosses the HPA target and cluster capacity is available.

## 4. Self-healing demonstration

```bash
kubectl delete pod -n taskflow -l app.kubernetes.io/component=backend --wait=false
kubectl get pods -n taskflow -w
```

Kubernetes should replace the deleted pod and the Service should continue routing to healthy replicas.

## 5. Observability demonstration

Open Grafana and show throughput, latency, error rate and business gauges. Then run:

```bash
python scripts/aiops_insights.py
```

The helper turns active Prometheus alerts into human-reviewable investigation suggestions. It does not modify infrastructure.


## 6. IaC and FinOps demonstration

Show that infrastructure is reproducible and cost-aware:

```bash
cd terraform/environments/prod
terraform plan

cd ../../workspaces
terraform workspace list
```

Show AWS resource tags (`Project`, `Environment`, `ManagedBy`), ECR lifecycle policies, bounded EKS node scaling and the optional AWS monthly budget. If Infracost is enabled in GitHub, show the Terraform cost breakdown produced for infrastructure pull requests.

## 7. AIOps demonstration

Trigger or inspect a Prometheus alert and run:

```bash
python scripts/aiops_insights.py --alert HighErrorRate
```

Explain that the current helper is the deterministic safety layer. An AI assistant can consume the same telemetry and suggest root-cause hypotheses, but destructive remediation remains human-approved.
