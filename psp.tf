resource "kubernetes_pod_security_policy_v1beta1" "this" {
  count = var.psp_enabled ? 1 : 0

  metadata {
    name        = "privileged-${var.name}"
    labels      = merge(local.common_labels, var.additional_labels)
    annotations = var.additional_annotations
  }

  spec {
    privileged           = true
    host_pid             = true
    host_ipc             = true
    host_network         = true
    allowed_capabilities = ["*"]
    volumes              = ["*"]

    host_ports {
      min = 1
      max = 65536
    }

    fs_group {
      rule = "RunAsAny"
    }

    run_as_user {
      rule = "RunAsAny"
    }

    se_linux {
      rule = "RunAsAny"
    }

    supplemental_groups {
      rule = "RunAsAny"
    }
  }
}
