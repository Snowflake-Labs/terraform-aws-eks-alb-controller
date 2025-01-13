# ------------------------------------------------------------------------------
# Amazon EBS CSI plugin for Kubernetes
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "ebs_csi_driver_irsa_assume_role_policy_doc" {
  count = length(var.addon_ebs_csi_driver) == 0 ? 0 : 1

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_url}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ebs_csi_driver_irsa_role" {
  count = length(var.addon_ebs_csi_driver) == 0 ? 0 : 1

  name               = "${local.eks_cluster_name}-ebs-csi-driver-irsa"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver_irsa_assume_role_policy_doc[0].json
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_irsa_policy_attachment" {
  count = length(var.addon_ebs_csi_driver) == 0 ? 0 : 1

  role       = aws_iam_role.ebs_csi_driver_irsa_role[0].name
  policy_arn = "arn:${var.arn_format}:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_addon" "ebs_csi_driver" {
  count = length(var.addon_ebs_csi_driver) == 0 ? 0 : 1

  cluster_name             = module.eks.cluster_id
  service_account_role_arn = aws_iam_role.ebs_csi_driver_irsa_role[0].arn
  addon_name               = var.addon_ebs_csi_driver["addon_name"]
  addon_version            = lookup(var.addon_ebs_csi_driver, "addon_version", null)
  resolve_conflicts        = lookup(var.addon_ebs_csi_driver, "resolve_conflicts", null)
}

# ------------------------------------------------------------------------------
# Amazon VPC CNI plugin for Kubernetes
# ------------------------------------------------------------------------------

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name_prefix      = "${local.eks_cluster_name}-vpc-cni-irsa"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}

resource "aws_eks_addon" "cni" {
  cluster_name             = module.eks.cluster_id
  addon_name               = var.addon_vpc_cni_driver["addon_name"]
  service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
  addon_version            = lookup(var.addon_vpc_cni_driver, "addon_version", null)
  resolve_conflicts        = lookup(var.addon_vpc_cni_driver, "resolve_conflicts", null)
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = module.eks.cluster_id
  addon_name        = var.addon_kube_proxy_driver["addon_name"]
  addon_version     = lookup(var.addon_kube_proxy_driver, "addon_version", null)
  resolve_conflicts = lookup(var.addon_kube_proxy_driver, "resolve_conflicts", null)
}

resource "aws_eks_addon" "core_dns" {
  cluster_name      = module.eks.cluster_id
  addon_name        = var.addon_coredns_driver["addon_name"]
  addon_version     = lookup(var.addon_coredns_driver, "addon_version", null)
  resolve_conflicts = lookup(var.addon_coredns_driver, "resolve_conflicts", null)
}
