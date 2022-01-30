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

variable "external_dns_zone_type" {
  description = "external-dns Helm chart AWS DNS zone type (public, private or empty for both)."
  type        = string
  default     = ""
}

variable "node_group_instance_size" {
  description = "external-dns Helm chart AWS DNS zone type (public, private or empty for both)."
  type        = list(string)
  default     = ["t3.xlarge"]
}

locals {
  eks_cluster_name = "${var.module_prefix}-cluster"
}
