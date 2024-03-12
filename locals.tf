locals {
  label_instance = { "app.kubernetes.io/instance" = var.name }
  label_name     = { "app.kubernetes.io/name" = var.name }
  label_version  = { "app.kubernetes.io/version" = var.image_tag }

  common_labels   = merge(local.label_name, local.label_instance, local.label_version)
  selector_labels = merge(local.label_name, local.label_instance)

  default_metrics_server_args = compact(flatten([[
    "--secure-port=${var.container_port}",
    "--cert-dir=/tmp",
    "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
    "--kubelet-use-node-status-port",
    "--metric-resolution=15s",
    var.whitelist_metrics_path ? "--authorization-always-allow-paths=/metrics" : "",
    var.api_service_insecure_skip_tls_verify ? "--kubelet-insecure-tls" : ""
  ], var.additional_args]))

  args = length(var.args_override) > 0 ? var.args_override : local.default_metrics_server_args

  nanny_cmd = [
    "/pod_nanny",
    "--config-dir=/etc/config",
    "--deployment=${var.name}",
    "--container=metrics-server",
    "--threshold=${var.addon_resizer_nanny_threshold}",
    "--poll-period=${var.addon_resizer_nanny_poll_period}",
    "--estimator=exponential",
    "--minClusterSize=${var.addon_resizer_nanny_min_cluster_size}",
    "--use-metrics=true"
  ]

  nanny_config = {
    base_cpu        = var.addon_resizer_nanny_cpu
    cpu_per_node    = var.addon_resizer_nanny_extra_cpu
    base_memory     = var.addon_resizer_nanny_memory
    memory_per_node = var.addon_resizer_nanny_extra_memory
  }
}
