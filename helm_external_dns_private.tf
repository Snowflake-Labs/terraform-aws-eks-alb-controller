resource "helm_release" "external_dns_private" {
  count      = var.aws_private_hosted_zone == null ? 1 : 0
  name       = "external-dns-private"
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "6.3.0"

  namespace = "kube-system"
  wait      = false

  values = [
    templatefile(
      "${path.module}/templates/external_dns_private_values.yaml",
      {
        aws_region                       = "${var.aws_region}",
        aws_private_hosted_zone          = "${local.private_dns_domain_name}",
        external_dns_eks_service_account = "${aws_iam_role.external_dns_private_role[0].name}",
        aws_iam_role_external_dns        = "${aws_iam_role.external_dns_private_role[0].name}",
        aws_iam_role_external_dns_arn    = "${aws_iam_role.external_dns_private_role[0].arn}",
      }
    )
  ]
}
