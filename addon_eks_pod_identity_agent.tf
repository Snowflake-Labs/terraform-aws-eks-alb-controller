resource "aws_eks_addon" "addon_eks_pod_identity_agent" {
  count = length(var.addon_eks_pod_identity_agent) == 0 ? 0 : 1

  cluster_name      = module.eks.cluster_id
  addon_name        = var.addon_eks_pod_identity_agent["addon_name"]
  addon_version     = lookup(var.addon_eks_pod_identity_agent, "addon_version", null)
  resolve_conflicts = lookup(var.addon_eks_pod_identity_agent, "resolve_conflicts", null)
}
