resource "kubernetes_service_v1" "this" {
  metadata {
    name        = length(var.service_name) > 0 ? var.service_name : var.name
    namespace   = var.namespace
    labels      = merge(local.common_labels, var.additional_labels, var.service_labels)
    annotations = merge(var.additional_annotations, var.service_annotations)
  }

  spec {
    port {
      name        = "https"
      protocol    = "TCP"
      port        = 443
      target_port = "https"
    }

    selector = local.selector_labels
  }
}
