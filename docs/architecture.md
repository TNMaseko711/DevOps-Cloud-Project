# Architecture

## AWS Topology
- Multi-AZ VPC with public and private subnets.
- EKS hosts stateless frontend and backend microservices.
- RDS PostgreSQL in private subnets with encrypted storage and automated backups.
- ALB provides HTTPS entry, routed to frontend and backend services.
- Observability stack includes Prometheus, Grafana, and CloudWatch alarms -> SNS.

## Security Controls
- Least-privilege IAM roles for EKS control plane and worker nodes.
- Security groups restrict DB access to EKS workloads.
- Secrets are injected via Kubernetes Secrets and should be sourced from AWS Secrets Manager at runtime.
- Image vulnerability scanning via Trivy in CI.

## Environments
- Dev and staging auto-deploy from main pipeline.
- Prod deploy is manual approval with rollout and rollback steps.
