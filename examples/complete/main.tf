module "example_cluster" {
  source = "../../"

  # Required
  env                = var.env
  aws_region         = var.aws_region
  module_prefix      = var.module_prefix
  kubernetes_version = var.kubernetes_version

  allowed_cidr_blocks            = var.allowed_cidr_blocks
  allowed_management_cidr_blocks = var.allowed_management_cidr_blocks

  vpc_id                = var.vpc_id
  private_subnet_ids    = var.private_subnet_ids

  aws_public_hosted_zone  = var.aws_public_hosted_zone
  aws_private_hosted_zone = var.aws_private_hosted_zone

  # Optional
  arn_format                = var.arn_format
  node_group_instance_sizes = var.node_group_instance_sizes

  # EKS aws-auth ConfigMap
  eks_aws_auth_configmap_enable = var.eks_aws_auth_configmap_enable
  eks_aws_auth_configmap_roles  = var.eks_aws_auth_configmap_roles
  eks_aws_auth_configmap_users  = var.eks_aws_auth_configmap_users
}
