locals {
  oidc_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
}

# 1. external-dns IAM Role Policy Document
data "aws_iam_policy_document" "external_dns_policy_doc" {
  statement {
    sid       = "ChangeResourceRecordSets"
    effect    = "Allow"
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/${local.aws_public_hosted_zone}"]
  }

  statement {
    sid = "ListResourceRecordSets"
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource",
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

# 2. external-dns IAM Role Policy
resource "aws_iam_policy" "external_dns_policy" {
  count       = local.aws_public_hosted_zone == true ? 1 : 0
  name        = "${var.module_prefix}-external-dns"
  path        = "/"
  description = "Policy for external-dns service"
  policy      = data.aws_iam_policy_document.external_dns_policy_doc.json
}

# 3. external-dns Assume Role Policy Document
data "aws_iam_policy_document" "external_dns_irsa_assume_role_policy_doc" {
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
      values   = ["system:serviceaccount:kube-system:${var.module_prefix}-external-dns"]
    }
  }
}

# 4. external-dns IAM Role
resource "aws_iam_role" "external_dns_role" {
  count              = local.aws_public_hosted_zone == true ? 1 : 0
  name               = "${var.module_prefix}-external-dns"
  assume_role_policy = data.aws_iam_policy_document.external_dns_irsa_assume_role_policy_doc.json
}

# 5. external-dns IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "external_dns_policy_attachment" {
  count      = local.aws_public_hosted_zone == true ? 1 : 0
  role       = aws_iam_role.external_dns_role[0].name
  policy_arn = aws_iam_policy.external_dns_policy[0].arn
}
