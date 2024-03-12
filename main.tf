resource "kubernetes_deployment_v1" "this" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    labels      = merge(local.common_labels, var.additional_labels, var.deployment_labels)
    annotations = merge(var.additional_annotations, var.deployment_annotations)
  }

  spec {
    replicas = var.deployment_replicas
    strategy {
      type = var.deployment_strategy
      dynamic "rolling_update" {
        for_each = var.deployment_strategy == "RollingUpdate" ? { create = true } : {}
        content {
          max_surge       = var.rolling_update_max_surge
          max_unavailable = var.rolling_update_max_unavailable
        }
      }
    }

    selector {
      match_labels = local.selector_labels
    }


    template {
      metadata {
        labels = merge(
          local.label_instance, local.label_name,
          var.additional_labels,
          var.pod_labels
        )
        annotations = merge(var.additional_annotations, var.pod_annotations)
      }

      spec {
        dynamic "image_pull_secrets" {
          for_each = var.image_pull_secrets
          content {
            name = each.value
          }
        }
        enable_service_links = var.enable_service_links
        service_account_name = kubernetes_service_account_v1.this.metadata[0].name
        priority_class_name  = var.priority_class_name
        host_network         = var.host_network_enabled

        container {
          name  = "metrics-server"
          image = "${var.image_repository}:v${var.image_tag}"
          args  = local.args

          port {
            name           = "https"
            container_port = var.container_port
            protocol       = "TCP"
          }

          dynamic "resources" {
            for_each = var.addon_resizer_enabled ? {} : { create = true }
            content {
              requests = var.resource_requests
              limits   = var.resource_limits
            }
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          liveness_probe {
            http_get {
              path   = "/livez"
              port   = "https"
              scheme = "HTTPS"
            }

            period_seconds    = 10
            failure_threshold = 3
          }

          readiness_probe {
            http_get {
              path   = "/readyz"
              port   = "https"
              scheme = "HTTPS"
            }

            initial_delay_seconds = 20
            period_seconds        = 10
            failure_threshold     = 3
          }

          image_pull_policy = var.image_pull_policy

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user                = 1000
            run_as_non_root            = true
            read_only_root_filesystem  = true
            allow_privilege_escalation = false

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        dynamic "container" {
          for_each = var.addon_resizer_enabled ? { create = true } : {}
          content {
            name              = "metrics-server-nanny"
            image             = "${var.addon_resizer_image_repository}:${var.addon_resizer_image_tag}"
            image_pull_policy = var.image_pull_policy
            command           = local.nanny_cmd

            env {
              name = "MY_POD_NAME"
              value_from {
                field_ref {
                  field_path = "metadata.name"
                }
              }
            }

            env {
              name = "MY_POD_NAMESPACE"
              value_from {
                field_ref {
                  field_path = "metadata.namespace"
                }
              }
            }

            resources {
              requests = var.addon_resizer_resource_requests
              limits   = var.addon_resizer_resource_limits
            }

            volume_mount {
              name       = "nanny-config-volume"
              mount_path = "/etc/config"
            }

            security_context {
              run_as_user                = 1000
              run_as_non_root            = true
              read_only_root_filesystem  = true
              allow_privilege_escalation = false

              capabilities {
                drop = ["ALL"]
              }

              seccomp_profile {
                type = "RuntimeDefault"
              }
            }
          }
        }

        volume {
          name = "tmp"
          empty_dir {}
        }

        dynamic "volume" {
          for_each = var.addon_resizer_enabled ? { create = true } : {}
          content {
            name = "nanny-config-volume"
            config_map {
              name = kubernetes_config_map_v1.metrics_server_nanny_config[0].metadata[0].name
            }
          }
        }

        node_selector = var.node_selector

        dynamic "toleration" {
          for_each = var.tolerations
          content {
            key                = each.key
            operator           = each.operator
            value              = each.value
            effect             = each.effect
            toleration_seconds = each.toleration_seconds
          }
        }

        dynamic "affinity" {
          for_each = var.deployment_replicas > 1 ? { create = true } : {}
          content {
            pod_anti_affinity {
              required_during_scheduling_ignored_during_execution {
                label_selector {
                  match_labels = local.selector_labels
                }
                namespaces   = [var.namespace]
                topology_key = "kubernetes.io/hostname"
              }
            }
          }
        }

      }
    }
  }
}
