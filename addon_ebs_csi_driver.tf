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
