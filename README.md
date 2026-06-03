# Roboshop Infrastructure — Terraform

Production-grade AWS infrastructure for the Roboshop e-commerce platform.

## Architecture

```
00-vpc           → VPC, subnets, NAT gateway, route tables
10-sg            → Security groups (one per component)
20-bastion        → Bastion host (public subnet)
30-sg-rules       → Security group ingress/egress rules
40-databases      → MongoDB, Redis, RabbitMQ EC2 instances
50-backend-alb    → Internal ALB for backend services
```

Each layer is an independent Terraform root module with its own remote state in S3. Layers communicate via AWS SSM Parameter Store — no `terraform_remote_state` data sources.

## Prerequisites

| Tool        | Version  |
|-------------|----------|
| Terraform   | >= 1.9   |
| AWS CLI     | >= 2.x   |
| aws-vault / SSO profile | configured |

## Repo Layout

```
.
├── components/          # Deployable root modules (one per layer)
│   ├── 00-vpc/
│   ├── 10-sg/
│   ├── 20-bastion/
│   ├── 30-sg-rules/
│   ├── 40-databases/
│   └── 50-backend-alb/
├── environments/        # Per-environment tfvars
│   ├── prod/
│   └── staging/
└── .github/workflows/   # CI/CD pipelines
```

## Deployment

```bash
# 1. Export environment
     export ENV=prod
     export AWS_PROFILE=roboshop-prod

# 2. Deploy each layer in order
for layer in 00-vpc 10-sg 20-bastion 30-sg-rules 40-databases 50-backend-alb; do
  cd components/$layer
  terraform init
  terraform plan -var-file=../../environments/$ENV/terraform.tfvars -out=tfplan
  terraform apply tfplan
  cd ../..
done
```

## Security Notes

- All secrets (remote user, passwords) are sourced from SSM Parameter Store (SecureString).
- No secrets are stored in `.tfvars` or version control.
- Bastion is the only resource with port 22 open to the internet. Prefer AWS Systems Manager Session Manager for zero-ingress access.
- S3 backend bucket must have versioning, SSE-S3/KMS, and public-access-block enabled.

## State Backend

| Layer          | S3 Key                                       |
|----------------|----------------------------------------------|
| vpc            | `roboshop/{env}/vpc/terraform.tfstate`       |
| sg             | `roboshop/{env}/sg/terraform.tfstate`        |
| bastion        | `roboshop/{env}/bastion/terraform.tfstate`   |
| sg-rules       | `roboshop/{env}/sg-rules/terraform.tfstate`  |
| databases      | `roboshop/{env}/databases/terraform.tfstate` |
| backend-alb    | `roboshop/{env}/backend-alb/terraform.tfstate`|

## Contributing

1. Branch from `main` → `feat/<name>` or `fix/<name>`
2. Run `terraform fmt -recursive` and `terraform validate` before pushing
3. PRs require at least one peer review
4. Merges to `main` trigger the `plan` workflow; apply is gated behind manual approval
