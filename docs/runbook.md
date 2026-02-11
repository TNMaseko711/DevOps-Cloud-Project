# Operations Runbook

## Manual Deployment
1. Build and push images to ECR with commit SHA tags.
2. Apply Terraform in target environment directory.
3. Update k8s manifests with image tags and apply overlay.

## Rollback
- If rollout fails: `kubectl rollout undo deployment/backend -n ecommerce-<env>`.
- Re-run smoke checks and watch pod readiness.

## Scaling
- Adjust HPA targets in `kubernetes/base/hpa.yaml`.
- Update EKS node group min/max in Terraform env variables.

## Troubleshooting
- Check pod status: `kubectl get pods -n ecommerce-<env>`.
- Check logs: `kubectl logs deploy/backend -n ecommerce-<env>`.
- Check alarms in CloudWatch and SNS subscriptions.
