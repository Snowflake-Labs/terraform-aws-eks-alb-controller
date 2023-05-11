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
  description = ""
  type        = list(string)
}

variable "env" {
  description = "Deployment environment."
  type        = string
}

variable "module_prefix" {
  description = "String to prefix resource names."
  type        = string
}

## Comment out as it's not being used in the module
#variable "hosted_zone_subdomain" {
#  description = "Hosted zone subdomain."
#  type        = string
#}

variable "aws_public_hosted_zone" {
  description = "Public Hosted zone subdomain."
  type        = string
  default     = null
}

variable "aws_public_hosted_zone_type" {
  description = "Public hosted zone type - public or private."
  type        = string
  default     = "public"
}

variable "aws_private_hosted_zone" {
  description = "Private Hosted zone subdomain."
  type        = string
  default     = null
}

variable "aws_private_hosted_zone_type" {
  description = "Private hosted zone type - public or private."
  type        = string
  default     = "private"
}


# Optional
variable "arn_format" {
  type        = string
  default     = "aws"
  description = "ARNs identifier, useful for GovCloud begin with `aws-us-gov-<region>`."
}

variable "external_dns_zone_type" {
  description = "external-dns Helm chart AWS DNS zone type (public, private or empty for both)."
  type        = string
  default     = ""
}

variable "node_group_instance_sizes" {
  description = "Node group instance sizes as a list of strings."
  type        = list(string)
  default     = ["t3.xlarge"]
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

variable "public_subnet_ids" {
  description = "Publlic subnet IDs to add kubernetes cluster on."
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

locals {
  eks_cluster_name       = "${var.module_prefix}-cluster"
  public_hosted_zone_id  = var.aws_public_hosted_zone == null ? "" : var.aws_public_hosted_zone
  private_hosted_zone_id = var.aws_private_hosted_zone == null ? "" : var.aws_private_hosted_zone
}
