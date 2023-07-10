output "eks_cluster_id" {
  value = module.example_cluster.eks_cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.example_cluster.cluster_endpoint
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console."
  value       = module.example_cluster.cluster_primary_security_group_id
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.example_cluster.cluster_security_group_id
}

output "node_security_group_id" {
  description = "Security group ids attached to the worker nodes of the cluster."
  value       = module.example_cluster.node_security_group_id
}

output "cluster_iam_role_name" {
  description = "Cluster IAM role name."
  value       = module.example_cluster.cluster_iam_role_name
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster."
  value       = module.example_cluster.cluster_iam_role_arn
}

output "aws_auth_configmap_yaml" {
  description = "Kubernetes configuration to authenticate to this EKS cluster."
  value       = module.example_cluster.aws_auth_configmap_yaml
}

output "eks_managed_node_groups" {
  description = "Outputs from node groups"
  value       = module.example_cluster.eks_managed_node_groups
}

