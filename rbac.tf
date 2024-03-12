resource "kubernetes_service_account_v1" "this" {
  metadata {
    name        = length(var.service_account_name) > 0 ? var.service_account_name : var.name
    namespace   = var.namespace
    labels      = merge(local.common_labels, var.service_account_labels)
    annotations = merge(var.additional_annotations, var.service_account_annotations)
  }
}


resource "kubernetes_cluster_role_v1" "system_aggregated_metrics_reader" {
  count = var.rbac_create ? 1 : 0

  metadata {
    name = "system:${var.name}-aggregated-reader"
    labels = merge({
      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
      "rbac.authorization.k8s.io/aggregate-to-edit"  = "true"
      "rbac.authorization.k8s.io/aggregate-to-view"  = "true"
      }, local.common_labels, var.additional_labels
    )
    annotations = var.additional_annotations
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods", "nodes"]
  }
}


resource "kubernetes_cluster_role_v1" "system_metrics_server" {
  count = var.rbac_create ? 1 : 0

  metadata {
    name        = "system:${var.name}"
    labels      = merge(local.common_labels, var.additional_labels)
    annotations = var.additional_annotations
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["nodes/metrics"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["pods", "nodes", "namespaces", "configmaps"]
  }
}


resource "kubernetes_cluster_role_binding_v1" "metrics_server_system_auth_delegator" {
  count = var.rbac_create ? 1 : 0

  metadata {
    name        = "${var.name}:system:auth-delegator"
    labels      = merge(local.common_labels, var.additional_labels)
    annotations = var.additional_annotations
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.this.metadata[0].name
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
}


resource "kubernetes_cluster_role_binding_v1" "system_metrics_server" {
  count = var.rbac_create ? 1 : 0

  metadata {
    name        = "system:${var.name}"
    labels      = merge(local.common_labels, var.additional_labels)
    annotations = var.additional_annotations
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.this.metadata[0].name
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.system_metrics_server[0].metadata[0].name
  }
}


resource "kubernetes_role_binding_v1" "metrics_server_auth_reader" {
  count = var.rbac_create ? 1 : 0

  metadata {
    name        = "${var.name}-auth-reader"
    namespace   = var.namespace
    labels      = merge(local.common_labels, var.additional_labels)
    annotations = var.additional_annotations
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.this.metadata[0].name
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "extension-apiserver-authentication-reader"
  }
}

# Addon-resizer related resources
resource "kubernetes_cluster_role_v1" "system_metrics_server_nanny" {
  count = (var.rbac_create && var.addon_resizer_enabled) ? 1 : 0

  metadata {
    name        = "system:${var.name}-nanny"
    labels      = merge(local.common_labels, var.additional_labels)
    annotations = var.additional_annotations
  }

  rule {
    non_resource_urls = ["/metrics"]
    verbs             = ["get"]
  }
}


resource "kubernetes_role_v1" "metrics_server_nanny" {
  count = (var.rbac_create && var.addon_resizer_enabled) ? 1 : 0

  metadata {
    name        = "system:${var.name}-nanny"
    namespace   = var.namespace
    labels      = merge(local.common_labels, var.additional_labels)
    annotations = var.additional_annotations
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get"]
  }
  rule {
    api_groups     = ["apps"]
    resources      = ["deployments"]
    resource_names = [kubernetes_deployment_v1.this.metadata[0].name]
    verbs          = ["get", "patch"]
  }
}


resource "kubernetes_cluster_role_binding_v1" "system_metrics_server_nanny" {
  count = (var.rbac_create && var.addon_resizer_enabled) ? 1 : 0

  metadata {
    name        = "system:${var.name}-nanny"
    labels      = merge(local.common_labels, var.additional_labels)
    annotations = var.additional_annotations
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.this.metadata[0].name
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.system_metrics_server_nanny[0].metadata[0].name
  }
}


resource "kubernetes_role_binding_v1" "metrics_server_nanny" {
  count = (var.rbac_create && var.addon_resizer_enabled) ? 1 : 0

  metadata {
    name        = "${var.name}-nanny"
    namespace   = var.namespace
    labels      = merge(local.common_labels, var.additional_labels)
    annotations = var.additional_annotations
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.this.metadata[0].name
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.metrics_server_nanny[0].metadata[0].name
  }
}
