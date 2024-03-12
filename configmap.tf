resource "kubernetes_config_map_v1" "metrics_server_nanny_config" {
  count = var.addon_resizer_enabled ? 1 : 0

  metadata {
    name        = "${var.name}-nanny-config"
    namespace   = var.namespace
    labels      = merge(local.common_labels, var.additional_labels)
    annotations = var.additional_annotations
  }

  data = {
    NannyConfiguration = templatefile("${path.module}/nanny_config.tftpl", { conf = local.nanny_config })
  }

}
