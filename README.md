# terraform-aws-eks-cluster
Terraform module to create AWS EKS cluster with EKS managed node groups, security groups, ALB controller and external DNS.  The module enable IAM Roles for Service Accounts (IRSA) on the EKS cluster.

## Required parameters
| Parameter| Description  |
| --- | --- |
|aws_region|AWS region where the resoruces will be created.|
|kubernetes_version|EKS version.|
|allowed_cidr_blocks|List of cidr to allow inbound traffic to the EKS cluster.|
|allowed_management_cidr_blocks|List of cidr to allow inbound traffic to the EKS management API.|
|env|Envornment name.|
|module_prefix|Resource name prefix.|
|vpc_id|VPC ID where the EKS cluster will be created.|


## Optional parameters
| Parameter| Description  |
| --- | --- |
|arn_format|ARN identifier, useful for GovCloud begin with `aws-us-gov-<region>`. Default `aws`|
|aws_public_hosted_zone|Route53 public hosted zone ID. Default: `null`|
|aws_private_hosted_zone|Route53 private hosted zone ID. Default: `null`
|node_group_instance_sizes|Node group instance sizes as a list of strings. Default: `t3.xlarge`|
|private_subnet_ids|Private subnet IDs to add kubernetes cluster on. Default: `[]`|
|public_subnet_ids|Publlic subnet IDs to add kubernetes cluster on. Default: `[]`|
|eks_aws_auth_configmap_enable|Enable managing the aws-auth configmap. Default: `false`|
|eks_aws_auth_configmap_roles|List of role maps to add to the EKS cluster aws-auth configmap, require eks_aws_auth_configmap_enable to be true. Default: `[]`|
|eks_aws_auth_configmap_users|List of user maps to add to the EKS cluster aws-auth configmap, require eks_aws_auth_configmap_enable to be true. Default: `[]`|



