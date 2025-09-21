output "cluster_name" { value = module.eks.cluster_name }
output "cluster_version" { value = module.eks.cluster_version }
output "cluster_endpoint" { value = module.eks.cluster_endpoint }
output "oidc_provider" { value = module.eks.oidc_provider }
output "node_group_names" { value = module.eks.node_groups } # map of node groups
