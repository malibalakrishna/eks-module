provider "aws" {}
condition {
test = "StringEquals"
variable = "${module.eks.oidc_provider}:sub"
values = ["system:serviceaccount:kube-system:cluster-autoscaler"]
}
}
}


resource "aws_iam_role" "cluster_autoscaler" {
name = "${var.cluster_name}-cluster-autoscaler"
assume_role_policy = data.aws_iam_policy_document.ca_assume.json
}


# Minimal policy for Cluster Autoscaler (managed node groups)
# (You can further scope this by cluster/nodegroup ARNs.)
resource "aws_iam_policy" "cluster_autoscaler" {
name = "${var.cluster_name}-cluster-autoscaler"
policy = jsonencode({
Version = "2012-10-17",
Statement = [
{
Effect = "Allow",
Action = [
"autoscaling:DescribeAutoScalingGroups",
"autoscaling:DescribeAutoScalingInstances",
"autoscaling:DescribeLaunchConfigurations",
"autoscaling:DescribeScalingActivities",
"autoscaling:SetDesiredCapacity",
"autoscaling:TerminateInstanceInAutoScalingGroup",
"ec2:DescribeLaunchTemplateVersions",
"eks:DescribeNodegroup",
"eks:ListNodegroups",
"eks:DescribeCluster"
],
Resource = "*"
}
]
})
}


resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
role = aws_iam_role.cluster_autoscaler.name
policy_arn = aws_iam_policy.cluster_autoscaler.arn
}


# 4) Deploy Cluster Autoscaler via Helm with IRSA annotation
resource "helm_release" "cluster_autoscaler" {
count = var.enable_cluster_autoscaler ? 1 : 0
name = "cluster-autoscaler"
repository = "https://kubernetes.github.io/autoscaler"
chart = "cluster-autoscaler"
version = var.cluster_autoscaler_chart_version
namespace = "kube-system"


values = [
yamlencode({
autoDiscovery = {
clusterName = var.cluster_name
}
awsRegion = data.aws_region.current.name
rbac = { serviceAccount = { create = true, name = "cluster-autoscaler" } }
extraArgs = {
balance-similar-node-groups = "true"
skip-nodes-with-system-pods = "false"
skip-nodes-with-local-storage = "false"
expander = "least-waste"
}
podAnnotations = {
"cluster-autoscaler.kubernetes.io/safe-to-evict" = "false"
}
serviceAccount = {
annotations = {
"eks.amazonaws.com/role-arn" = aws_iam_role.cluster_autoscaler.arn
}
}
})
]
}


data "aws_region" "current" {}
