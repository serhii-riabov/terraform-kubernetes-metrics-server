resource "kubernetes_api_service_v1" "this" {
  metadata {
    name        = "v1beta1.metrics.k8s.io"
    labels      = merge(local.common_labels, var.additional_labels, var.api_service_labels)
    annotations = merge(var.additional_annotations, var.api_service_annotations)
  }
  spec {
    service {
      namespace = var.namespace
      name      = var.name
    }
    group                    = "metrics.k8s.io"
    version                  = "v1beta1"
    insecure_skip_tls_verify = var.api_service_insecure_skip_tls_verify
    ca_bundle                = var.api_service_ca_bundle
    group_priority_minimum   = 100
    version_priority         = 100
  }
}
