# Git Workflow

Recommended TaskFlow workflow:

```text
feature/* -> pull request -> develop -> release/main
```

For a small internship repository, `main` may be the protected production branch and `feature/*` branches can merge through pull requests. Enable branch protection in GitHub so direct pushes to `main` are blocked and CI must pass before merge.

## GitOps distinction

TaskFlow uses Git as the source of truth for application and infrastructure configuration. It does not claim a full GitOps controller such as Argo CD or Flux. The production CD workflow performs the deployment directly with GitHub Actions and Helm.
