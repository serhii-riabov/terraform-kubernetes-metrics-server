resource "kubernetes_manifest" "service_monitor" {
  count = var.servicemonitor_enabled ? 1 : 0

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name        = var.name
      namespace   = length(var.servicemonitor_namespace) > 0 ? var.servicemonitor_namespace : var.namespace
      labels      = merge(local.common_labels, var.additional_labels, var.servicemonitor_labels)
      annotations = merge(var.additional_annotations, var.servicemonitor_annotations)
    }
    spec = {
      jobLabel = var.name
      namespaceSelector = {
        matchNames = [
          var.namespace
        ]

      }
      selector = {
        matchLabels = local.selector_labels
      }
      endpoints = [
        {
          port   = "https"
          path   = "/metrics"
          scheme = "https"
          tlsConfig = {
            insecureSkipVerify = true
          }
          interval      = var.servicemonitor_interval
          scrapeTimeout = var.servicemonitor_scrape_timeout
        }
      ]
    }
  }
}
