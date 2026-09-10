terraform {
  backend "s3" {
    # Configure bucket/key/region with terraform init -backend-config=backend.hcl
    # Native S3 state locking is enabled for Terraform >= 1.10.
    use_lockfile = true
  }
}
