# Required
variable "aws_region" {
  description = "AWS Region."
  type        = string
}

variable "kubernetes_version" {
  description = "The version of the EKS cluster to create."
  type        = string
}

variable "env" {
  description = "Deployment environment."
  type        = string
}

variable "module_prefix" {
  description = "String to prefix resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be created."
  type        = string
}


# Optional
variable "arn_format" {
  type        = string
  default     = "aws"
  description = "ARNs identifier, useful for GovCloud begin with `aws-us-gov-<region>`."
}

variable "aws_public_hosted_zone" {
  description = "Public Hosted zone subdomain."
  type        = string
  default     = null
}

variable "aws_private_hosted_zone" {
  description = "Private Hosted zone subdomain."
  type        = string
  default     = null
}

variable "node_group_instance_sizes" {
  description = "Node group instance sizes as a list of strings."
  type        = list(string)
  default     = ["t3.xlarge"]
}

variable "private_subnet_ids" {
  description = "Private subnet IDs to add kubernetes cluster on."
  type        = list(string)
  default     = []
}

variable "public_subnet_ids" {
  description = "Publlic subnet IDs to add kubernetes cluster on."
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "List of cidr to allow inbound traffic to the EKS cluster."
  type        = list(string)
  default     = []
}

variable "allowed_management_cidr_blocks" {
  description = "List of cidr to allow inbound traffic to the EKS management API."
  type        = list(string)
  default     = []
}

variable "eks_aws_auth_configmap_enable" {
  description = "Determines whether to manage the aws-auth configmap"
  type        = bool
  default     = false
}

variable "eks_aws_auth_configmap_roles" {
  description = "List of role maps to add to the EKS cluster aws-auth configmap, require eks_aws_auth_configmap_enable to be true"
  type        = list(any)
  default     = []
}

variable "eks_aws_auth_configmap_users" {
  description = "List of user maps to add to the EKS cluster aws-auth configmap, require eks_aws_auth_configmap_enable to be true"
  type        = list(any)
  default     = []
}

variable "create_logs_bucket" {
  description = "Flag to create an S3 bucket or not."
  type        = bool
  default     = false
}

variable "load_balancer_account_id" {
  description = <<EOF
Load Balancer account ID for the given region you deployed your load balancer in based on this list:
https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html#attach-bucket-policy.
EOF
  type        = string
  default     = "797873946194"
}

variable "addon_ebs_csi_driver" {
  description = "Install Amazon EBS CSI driver add-on. Require for EKS cluster version 1.23 and above. For content, refer to 'aws_eks_addon' Terraform resource."
  type        = map(string)
  default     = {}
}

# https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1904
variable "cluster_iam_role_dns_suffix" {
  description = "Base DNS domain name for the current partition (e.g., amazonaws.com in AWS Commercial, amazonaws.com.cn in AWS China)"
  type        = string
  default     = null
}


locals {
  eks_cluster_name       = "${var.module_prefix}-cluster"
  public_hosted_zone_id  = var.aws_public_hosted_zone == null ? "" : var.aws_public_hosted_zone
  private_hosted_zone_id = var.aws_private_hosted_zone == null ? "" : var.aws_private_hosted_zone
}
