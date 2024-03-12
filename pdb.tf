resource "kubernetes_pod_disruption_budget_v1" "this" {
  count = var.pdb_enabled ? 1 : 0

  metadata {
    name        = var.name
    namespace   = var.namespace
    labels      = merge(local.common_labels, var.additional_labels)
    annotations = var.additional_annotations
  }
  spec {
    max_unavailable = var.pdb_max_unavailable
    min_available   = var.pdb_min_available
    selector {
      match_labels = local.selector_labels
    }
  }
}
