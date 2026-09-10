---
paths:
  - "**/*.tf"
  - "**/*.tofu"
  - "**/*.tfvars"
---
# Infrastructure (OpenTofu)
- Providers: Scaleway (primary, EU), GCP (non-EU only). Never propose AWS/Azure.
- Run `tofu fmt && tofu validate && tofu plan` and show the plan. Never run `tofu apply` or `tofu destroy` without an explicit go.
- Secrets never in `.tf` files or state committed to git; use the secret manager already wired in the repo.
