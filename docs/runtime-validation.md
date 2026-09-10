# TaskFlow Runtime Validation

This checklist is the final proof that the capstone works end-to-end. Static files alone are not sufficient.

## Local Docker validation

```bash
cp .env.example .env
# Set a strong SECRET_KEY and GRAFANA_ADMIN_PASSWORD in .env
make docker-up
make monitoring-up
curl --fail http://localhost:8000/api/health
curl --fail http://localhost:3000/health
curl --fail http://localhost:9090/-/ready
curl --fail http://localhost:3001/api/health
```

## Terraform validation

```bash
terraform fmt -check -recursive terraform
cd terraform/environments/dev
terraform init -backend=false
terraform validate
terraform plan
```

For remote state, bootstrap the S3 backend first and initialize the environment with `backend-config`.

## Kubernetes validation

```bash
helm lint ./helm/taskflow -f ./helm/taskflow/values-prod.yaml
kubectl kustomize kubernetes/overlays/prod >/tmp/taskflow.yaml
helm upgrade --install taskflow ./helm/taskflow -n taskflow --create-namespace -f ./helm/taskflow/values-prod.yaml
kubectl get pods -n taskflow
kubectl get svc -n taskflow
kubectl get hpa -n taskflow
kubectl get pvc -n taskflow
```

## Required live demonstrations

1. Push a change and show CI tests.
2. Introduce a controlled vulnerable image/dependency and show Trivy fail the pipeline.
3. Publish an immutable Git-SHA image to ECR.
4. Deploy with Helm, show the Alembic migration hook completes, then verify `/api/ready/schema` returns the active Alembic revision.
5. Open the application through Ingress.
6. Show Prometheus scraping TaskFlow metrics and Grafana dashboards.
7. Generate load and show HPA scaling.
8. Delete a backend Pod and show Kubernetes self-heal it.
9. Show an SLO/alert and run the AIOps triage helper; remediation remains human-approved.
10. Show Terraform remote state, workspace selection, and a reviewed plan.
