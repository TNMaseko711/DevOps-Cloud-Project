# DevOps + Cloud Project: Automated Multi-Environment Microservices Deployment

This repository demonstrates an end-to-end DevOps platform for deploying a 3-tier e-commerce microservices app (frontend, backend API, PostgreSQL) to AWS across **dev**, **staging**, and **production** using Terraform, EKS, GitHub Actions, and observability tooling.

## Repository Layout
- `services/`: frontend, backend, database container definitions and tests.
- `terraform/`: modular IaC and environment stacks.
- `kubernetes/`: base manifests and env overlays for EKS.
- `.github/workflows/`: CI pipeline + progressive deployments.
- `monitoring/`: Prometheus scrape config and Grafana dashboard.
- `docs/`: architecture notes, diagrams, and runbook.

## Prerequisites
- AWS account with OIDC trust for GitHub Actions.
- Terraform >= 1.6, kubectl, docker, Python 3.12.
- ECR repositories: `frontend` and `backend`.
- Domain + ACM certificate for production ingress.

## Local Setup
```bash
cd services/backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements-dev.txt
pytest
```

```bash
cd services/frontend
pytest tests/test_frontend.py
```

## Terraform Setup
```bash
cd terraform/environments/dev
terraform init
terraform plan -var="db_password=REPLACE_ME"
terraform apply -var="db_password=REPLACE_ME"
```

Repeat for `staging` and `prod` directories (with different credentials and CIDRs). Use separate remote state keys/workspaces for strict environment isolation.

## CI/CD Flow
1. **CI (`ci.yml`)**: lint, tests, Terraform formatting, Docker build, Trivy scan.
2. **Deploy Dev**: automatic after CI success on main.
3. **Deploy Staging**: automatic after successful dev deployment.
4. **Deploy Prod**: manual trigger/approval gate with rollback actions.

## Security Practices
- No hardcoded cloud credentials; GitHub OIDC role assumed at runtime.
- Encrypted Terraform remote state (S3 + DynamoDB locking).
- DB in private subnets with SG restriction.
- Trivy image vulnerability scanning in CI.
- Kubernetes network policy and secret objects.

## Observability
- Prometheus scrapes backend metrics endpoint `/metrics`.
- Grafana dashboard includes request rate, p95 latency, and pod restarts.
- CloudWatch alarms and SNS topic are provisioned through Terraform.

## Cost Controls
- Dev uses spot-backed worker nodes.
- Right-sized RDS classes (`db.t4g.micro` dev, `db.t4g.small` higher envs).
- HPA and node-group autoscaling reduce idle capacity.
- Suggested monthly target: keep always-on resources minimal and tear down non-prod after hours.

## ADR Highlights
1. **EKS over ECS** for richer ecosystem and Kubernetes-native scaling patterns.
2. **Terraform modules** to maximize reuse and maintain drift control.
3. **Progressive promotion pipeline** (dev -> staging -> prod) for risk reduction.
