resource "helm_release" "external_dns" {
  count      = var.aws_public_hosted_zone == null ? 0 : 1
  name       = "external-dns"
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "6.14.1"

  namespace = "kube-system"
  wait      = false

  values = [
    templatefile(
      "${path.module}/templates/external_dns_values.yaml",
      {
        aws_region                       = "${var.aws_region}",
        aws_zone_type                    = "${var.aws_public_hosted_zone_type}",
        aws_public_hosted_zone           = "${local.public_hosted_zone_id}"
        external_dns_eks_service_account = "${aws_iam_role.external_dns_role[0].name}",
        aws_iam_role_external_dns        = "${aws_iam_role.external_dns_role[0].name}",
        aws_iam_role_external_dns_arn    = "${aws_iam_role.external_dns_role[0].arn}",
        eks_cluster_id                   = "${module.eks.cluster_id}",
      }
    )
  ]
}
