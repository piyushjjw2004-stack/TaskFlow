# TaskFlow Technical Interview Preparation Guide

This document contains 23 core technical interview questions and placement-focused answers based on the **TaskFlow DevOps Task Management Platform**.

---

### 1. Why Docker?
**Answer**: Docker provides OS-level virtualization to containerize applications with all their dependencies (libraries, runtimes, configurations). This eliminates the "it works on my machine" problem by ensuring consistent execution across development, testing, and production environments while offering lightweight startup times and high density compared to virtual machines.

### 2. Docker vs Virtual Machines (VMs)
**Answer**: 
- **VMs**: Include a full guest operating system, managed by a Hypervisor (Type 1 or Type 2). They consume gigabytes of memory, take minutes to boot, and have higher CPU overhead.
- **Docker Containers**: Share the host OS kernel and run as isolated user-space processes using Linux namespaces (PID, NET, MNT) and cgroups. They start in seconds and consume minimal overhead.

### 3. Docker Compose vs Kubernetes
**Answer**:
- **Docker Compose**: A tool for defining and running multi-container Docker applications on a single host. It is ideal for local development, testing, and single-node staging.
- **Kubernetes**: An enterprise-grade container orchestration system designed to manage containerized workloads across multi-node clusters with automated scaling, self-healing, rolling updates, ingress routing, and service discovery.

### 4. What is CI/CD?
**Answer**: 
- **Continuous Integration (CI)**: The automated practice of building, linting, and testing code changes whenever developers push code to version control, catching bugs early.
- **Continuous Delivery / Deployment (CD)**: The automated process of packaging validated code into artifacts (e.g., Docker images), pushing them to registries (ECR), and making validated artifacts available for target environments; a live Kubernetes deployment requires a configured cluster and deployment credentials.

### 5. What happens in your GitHub Actions pipeline?
**Answer**: 
1. **CI Pipeline (`ci.yml`)**: On PR/push, spins up a PostgreSQL service container, runs Pytest backend test suite, executes TypeScript linting/Vite React build, and verifies multi-stage Dockerfile builds.
2. **Security Pipeline (`security.yml`)**: Runs Trivy scanner against the repository filesystem and Docker images for CVE vulnerabilities.
3. **CD Pipeline (`cd.yml`)**: On push to `main`, assumes the AWS deployment role through GitHub OIDC, builds and tags immutable Git-SHA container images, pushes them to ECR, deploys the Helm release to EKS, applies monitoring resources, and runs rollout/smoke-test verification.

### 6. Why Trivy?
**Answer**: Trivy is an open-source vulnerability scanner specifically designed for containers, filesystems, and IaC code. We integrate Trivy into CI/CD to scan container images before deployment, failing builds if `HIGH` or `CRITICAL` vulnerabilities are detected, enforcing DevSecOps compliance.

### 7. What is Infrastructure as Code (IaC)?
**Answer**: IaC is the practice of managing and provisioning cloud infrastructure (VPCs, EC2 instances, EKS clusters, IAM roles) through machine-readable definition files rather than manual point-and-click cloud console management. This guarantees idempotency, version control, and reproducible environments.

### 8. Why Terraform?
**Answer**: Terraform is an open-source, declarative IaC tool supporting multi-cloud providers (AWS, Azure, GCP). It maintains a state file (`terraform.tfstate`) to map real-world infrastructure to configuration code, allowing developers to preview changes via `terraform plan` before applying them.

### 9. Terraform vs Ansible
**Answer**:
- **Terraform**: Primarily an **Infrastructure Provisioning** tool. It uses declarative HCL to build cloud resources (VPCs, Subnets, EKS, RDS).
- **Ansible**: Primarily a **Configuration Management** tool. It uses procedural/declarative YAML playbooks over agentless SSH to configure operating systems, install software packages (Docker), and tweak kernel parameters.

### 10. What does Ansible do in TaskFlow?
**Answer**: Ansible automates post-provisioning node setup. Its playbooks run roles that update system packages (`common`), install Docker CE and containerd (`docker`), disable swap, load kernel modules (`overlay`, `br_netfilter`), and set sysctl networking parameters required for Kubernetes nodes (`k8s_prep`).

### 11. What is Kubernetes?
**Answer**: Kubernetes (K8s) is an open-source container orchestration platform designed to automate deployment, scaling, management, and networking of containerized applications across a cluster of nodes.

### 12. Pod vs Deployment vs Service
**Answer**:
- **Pod**: The smallest deployable unit in K8s, wrapping one or more co-located containers sharing network IP and storage.
- **Deployment**: A declarative controller managing Pod replicas, facilitating self-healing, scaling, and zero-downtime rolling updates.
- **Service**: An abstraction defining a logical set of Pods and a policy to access them (ClusterIP, NodePort, LoadBalancer), providing stable virtual IP address and DNS resolution.

### 13. What is Ingress?
**Answer**: Ingress is an API object that manages external HTTP/HTTPS access to services within a cluster. In TaskFlow, the NGINX Ingress Controller routes incoming traffic based on host/path rules (e.g., `/api/*` -> Backend Service, `/*` -> Frontend Service).

### 14. What is Helm?
**Answer**: Helm is the package manager for Kubernetes. It uses template charts (`Chart.yaml`, `values.yaml`, `templates/`) to combine multiple Kubernetes manifests into a single, versioned release that can be installed (`helm install`) or upgraded (`helm upgrade`) cleanly.

### 15. What is Horizontal Pod Autoscaler (HPA)?
**Answer**: HPA automatically scales the number of Pod replicas in a Deployment based on observed metrics (CPU/Memory utilization). In TaskFlow, HPA scales backend Pods between 2 and 5 replicas when CPU exceeds 70% or Memory exceeds 80%.

### 16. What are Readiness and Liveness Probes?
**Answer**:
- **Liveness Probe**: Determines if a container is running. If it fails, Kubernetes kills the container and restarts it. (TaskFlow checks `/api/health`).
- **Readiness Probe**: Determines if a container is ready to accept user traffic. If it fails, Kubernetes removes the Pod IP from Service endpoints. (TaskFlow checks `/api/ready` which verifies database connection).

### 17. How does Prometheus work?
**Answer**: Prometheus is a time-series monitoring system that uses a **pull-based model** to scrape HTTP metrics endpoints (`/api/metrics`) at configured intervals. It evaluates alert rules (`alerts.yml`) and stores metrics in a time-series database.

### 18. Why Grafana?
**Answer**: Grafana is an open-source visualization platform that connects to Prometheus as a datasource. It renders customizable, real-time dashboards displaying HTTP throughput, latency percentiles (p95, p99), error rates, and system metrics.

### 19. How does your application scale?
**Answer**:
1. **Vertical Scaling**: Resource requests and limits defined in Kubernetes manifests.
2. **Horizontal Scaling**: Kubernetes HPA increases backend pod replicas up to 5 based on load.
3. **Cluster Capacity**: AWS EKS Managed Node Groups are provisioned with bounded min/max capacity. Pod-level HPA is implemented; a Cluster Autoscaler/Karpenter controller is intentionally not included in this capstone and would be the next layer for automatic node scaling.

### 20. How do you secure secrets?
**Answer**: Secrets are never committed to Git. In local development, `.env` is ignored. In Kubernetes, values are injected via Kubernetes `Secret` objects. In AWS production, For a real AWS deployment, AWS Secrets Manager or another external secret manager should be preferred over storing plaintext values in Git. The GitHub Actions workflow creates the Kubernetes Secret only at deployment time from repository secrets.

### 21. How would you deploy this to AWS?
**Answer**:
1. Review and validate Terraform configuration. A real `terraform apply` requires AWS credentials and incurs cloud costs, so it is not part of the default capstone verification.
2. Push container images to ECR using GitHub Actions CD pipeline.
3. The CD workflow configures `kubectl`, installs cluster dependencies, creates the runtime Secret, deploys Helm, applies monitoring resources, and verifies the rollout.
4. For a manual deployment, use `helm upgrade --install taskflow ./helm/taskflow --values ./helm/taskflow/values-prod.yaml` after configuring the runtime Secret and cluster addons.

### 22. What happens when a pod crashes?
**Answer**:
1. The K8s Kubelet detects the process exit or Liveness probe failure.
2. Kubelet restarts the container according to the `restartPolicy: Always`.
3. If the crash persists, K8s enters a `CrashLoopBackOff` state, applying exponential backoff delay before retrying.
4. Meanwhile, the Deployment controller ensures target replica counts are met, spinning up new Pods if necessary.

### 23. How would you troubleshoot a failed deployment?
**Answer**:
1. Check Pod status: `kubectl get pods -n taskflow`
2. Describe Pod events: `kubectl describe pod <pod-name> -n taskflow`
3. Inspect container logs: `kubectl logs <pod-name> -n taskflow --previous`
4. Verify service endpoints: `kubectl get endpoints -n taskflow`
5. Test readiness probe manually inside container or check DB connection strings in ConfigMaps/Secrets.
