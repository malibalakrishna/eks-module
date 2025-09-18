output "cluster_autoscaler_iam_role_arn" {
  description = "IAM role ARN for cluster autoscaler"
  value       = aws_iam_role.cluster_autoscaler.arn
}

output "cluster_autoscaler_iam_role_name" {
  description = "IAM role name for cluster autoscaler"
  value       = aws_iam_role.cluster_autoscaler.name
}