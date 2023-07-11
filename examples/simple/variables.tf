variable "env" {
  description = "Deployment environment."
  type        = string
}

variable "aws_region" {
  description = "AWS Region."
  type        = string
}

variable "kubernetes_version" {
  description = "The version of the EKS cluster to create for sentry."
  type        = string
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

variable "hosted_zone_subdomain" {
  description = "Hosted zone subdomain."
  type        = string
}

variable "aws_private_hosted_zone" {
  description = "Private Route53 hosted zone subdomain."
  type        = string
  default     = null
}

variable "module_prefix" {
  description = "String to prefix resource names."
  type        = string
}

locals {
  eks_cluster_name = "${var.module_prefix}-cluster"
}
