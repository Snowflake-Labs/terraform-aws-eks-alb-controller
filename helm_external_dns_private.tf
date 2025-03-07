resource "helm_release" "external_dns_private" {
  count      = var.aws_private_hosted_zone == null ? 0 : 1
  name       = "external-dns-private"
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "8.3.9"

  namespace = "kube-system"
  wait      = false

  values = [
    templatefile(
      "${path.module}/templates/external_dns_private_values.yaml",
      {
        aws_region                       = "${var.aws_region}",
        aws_zone_type                    = "private",
        aws_private_hosted_zone          = "${local.private_hosted_zone_id}",
        external_dns_eks_service_account = "${aws_iam_role.external_dns_private_role[0].name}",
        aws_iam_role_external_dns        = "${aws_iam_role.external_dns_private_role[0].name}",
        aws_iam_role_external_dns_arn    = "${aws_iam_role.external_dns_private_role[0].arn}",
        eks_cluster_id                   = "${module.eks.cluster_id}",
        image_registry                   = "${try(var.overwrite_image_variables["external-dns"]["registry"], null)}",
        image_repository                 = "${try(var.overwrite_image_variables["external-dns"]["repository"], null)}",
        image_tag                        = "${try(var.overwrite_image_variables["external-dns"]["tag"], null)}",
      }
    )
  ]
}
