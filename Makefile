# TaskFlow DevOps Task Management Platform
.PHONY: help install test lint build docker-build docker-up docker-down docker-config monitoring-up monitoring-down k8s-deploy k8s-delete helm-install helm-upgrade terraform-validate ansible-check validate capstone-validate

help:
	@echo "TaskFlow DevOps Commands:"
	@echo "  make install             Install backend & frontend dependencies"
	@echo "  make test                Run backend pytest suite"
	@echo "  make lint                Run frontend TypeScript checks"
	@echo "  make build               Build frontend production bundle"
	@echo "  make docker-build        Build backend & frontend images"
	@echo "  make docker-up           Start local application stack"
	@echo "  make docker-down         Stop local application stack"
	@echo "  make docker-config       Validate all Docker Compose files"
	@echo "  make monitoring-up       Start local Prometheus + Grafana"
	@echo "  make monitoring-down     Stop local monitoring stack"
	@echo "  make k8s-deploy          Apply Kustomize production overlay"
	@echo "  make k8s-delete          Delete Kustomize production overlay"
	@echo "  make helm-install        Install Helm chart"
	@echo "  make helm-upgrade        Upgrade Helm release"
	@echo "  make terraform-validate  Validate Terraform"
	@echo "  make ansible-check       Syntax-check Ansible"
	@echo "  make validate             Run project validation script"
	@echo "  make workspace-demo       Show Terraform workspace workflow"

install:
	pip install -r backend/requirements.txt
	cd frontend && npm ci

test:
	python -m pytest backend/tests -v

lint:
	cd frontend && npm run lint

build:
	cd frontend && npm run build

docker-build:
	docker build -t taskflow-backend:latest ./backend
	docker build -t taskflow-frontend:latest ./frontend

docker-up:
	docker compose up -d --build

docker-down:
	docker compose down -v

docker-config:
	docker compose -f docker-compose.yml config >/dev/null
	docker compose -f docker-compose.prod.yml config >/dev/null
	docker compose -f docker-compose.monitoring.yml config >/dev/null
	@echo "Docker Compose configuration is valid."

monitoring-up:
	docker network inspect taskflow-network >/dev/null 2>&1 || docker network create taskflow-network
	docker compose -f docker-compose.monitoring.yml up -d

monitoring-down:
	docker compose -f docker-compose.monitoring.yml down -v

k8s-deploy:
	kubectl delete job taskflow-migration -n taskflow --ignore-not-found
	kubectl apply -k kubernetes/overlays/prod

k8s-delete:
	kubectl delete -k kubernetes/overlays/prod

helm-install:
	helm upgrade --install taskflow ./helm/taskflow --namespace taskflow --create-namespace

helm-upgrade:
	helm upgrade --install taskflow ./helm/taskflow --namespace taskflow

terraform-validate:
	cd terraform/environments/dev && terraform init -backend=false && terraform validate

ansible-check:
	cd ansible && ansible-playbook playbooks/site.yml --syntax-check

validate:
	bash scripts/validate.sh


workspace-demo:
	@echo "Terraform workspace demo:"
	@echo "  cd terraform/workspaces && terraform workspace list"
	@echo "  terraform workspace new dev"
	@echo "  terraform workspace new prod"
	@echo "  terraform workspace select dev"
	@echo "  terraform workspace select prod"

capstone-validate:
	bash scripts/capstone-validate.sh
