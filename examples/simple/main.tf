module "example_cluster" {
  source = "../../"

  env                = var.env
  aws_region         = var.aws_region
  module_prefix      = var.module_prefix
  kubernetes_version = var.kubernetes_version

  vpc_id                = var.vpc_id
  private_subnet_ids    = var.private_subnet_ids

  aws_private_hosted_zone = var.aws_private_hosted_zone
}
