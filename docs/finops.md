# FinOps Controls

TaskFlow treats cost as an operational metric, not an afterthought. The Terraform stack applies Project, Environment, and ManagedBy tags to AWS resources.

## Controls

1. Keep dev and prod infrastructure in separate Terraform roots.
2. Use small dev node types and lower node counts.
3. Keep EKS node autoscaling bounded by `min_node_count` and `max_node_count`.
4. Prefer immutable images and automated cleanup of unused images in the registry.
5. Review Terraform plans before production changes.
6. Optionally enable the Terraform-managed AWS monthly budget and 80% forecast notification.

## Optional CI cost gate

Infracost can be added to pull requests with an `INFRACOST_API_KEY`. The project deliberately does not hard-code a paid API key. A production implementation should post estimated monthly deltas on pull requests and require review above a chosen threshold.
