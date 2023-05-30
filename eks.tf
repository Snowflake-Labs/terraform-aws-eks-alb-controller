module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.20.5"

  cluster_name                         = local.eks_cluster_name
  cluster_version                      = var.kubernetes_version
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = var.allowed_management_cidr_blocks

  # EKS aws-auth ConfigMap
  manage_aws_auth_configmap = var.eks_aws_auth_configmap_enable
  aws_auth_roles            = var.eks_aws_auth_configmap_roles
  aws_auth_users            = var.eks_aws_auth_configmap_users

  vpc_id      = var.vpc_id
  subnet_ids  = var.private_subnet_ids
  enable_irsa = true

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
  cloudwatch_log_group_retention_in_days = 0

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    disk_size      = 50
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    node-group-1 = {
      min_size     = 3
      max_size     = 5
      desired_size = 3

      instance_types = var.node_group_instance_sizes
      capacity_type  = "ON_DEMAND"
      labels = {
        environment = "${var.env}"
      }

      update_config = {
        max_unavailable_percentage = 80 # or set `max_unavailable`
      }

      tags = {
        environment = "${var.env}"
      }
    }
  }

  cluster_security_group_additional_rules = {
    admin_access = {
      description = "Admin ingress to Kubernetes API."
      cidr_blocks = var.allowed_cidr_blocks
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
    }

    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node SG port range 1025-65535."
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_from_cluster_port_9443 = {
      description                   = "control-plane to data-plane ingress 9443."
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      type                          = "ingress"
      source_cluster_security_group = true
    }

    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    egress_all = {
      description      = "Node to default all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  cluster_timeouts = {
    create = "30m"
    delete = "30m"
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "available" {
}
