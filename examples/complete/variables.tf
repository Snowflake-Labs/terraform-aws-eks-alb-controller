# Required
variable "aws_region" {
  description = "AWS Region."
  type        = string
}

variable "kubernetes_version" {
  description = "The version of the EKS cluster to create for sentry."
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "List of cidr to allow inbound traffic to the EKS cluster."
  type        = list(string)
  default     = null
}

variable "allowed_management_cidr_blocks" {
  description = "List of cidr to allow inbound traffic to the EKS management API."
  type        = list(string)
  default     = null
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be created."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs to add kubernetes cluster on."
  type        = list(string)
  default     = []
}

variable "aws_public_hosted_zone" {
  description = "Public Route53 hosted zone domain."
  type        = string
  default     = null
}

variable "aws_private_hosted_zone" {
  description = "Private Route53 hosted zone subdomain."
  type        = string
  default     = null
}

variable "env" {
  description = "Deployment environment."
  type        = string
}

variable "module_prefix" {
  description = "String to prefix resource names."
  type        = string
}

variable "hosted_zone_subdomain" {
  description = "Hosted zone subdomain."
  type        = string
}

# Optional
variable "arn_format" {
  type        = string
  default     = "aws"
  description = "ARNs identifier, useful for GovCloud begin with `aws-us-gov-<region>`."
}

variable "node_group_instance_sizes" {
  description = "Node group instance sizes as a list of strings."
  type        = list(string)
  default     = ["t3.xlarge"]
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

locals {
  eks_cluster_name = "${var.module_prefix}-cluster"
}
