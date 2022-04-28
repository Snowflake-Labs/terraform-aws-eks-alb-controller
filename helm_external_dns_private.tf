resource "helm_release" "external_dns_private" {
  name       = "external-dns-private"
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "6.1.1"

  namespace = "kube-system"
  wait      = false

  values = [
    templatefile(
      "${path.module}/templates/external_dns_values.yaml",
      {
        aws_region                       = "${var.aws_region}",
        aws_zone_type                    = "private",
        aws_private_hosted_zone          = "${var.aws_private_hosted_zone}",
        external_dns_eks_service_account = "external-dns-private",
        aws_iam_role_external_dns        = "${aws_iam_role.external_dns_private_role.name}",
        aws_iam_role_external_dns_arn    = "${aws_iam_role.external_dns_private_role.arn}",
      }
    )
  ]
}
