# Kubernetes Metrics Server Terraform module
Native Terraform module which deploys [Metrics Server](https://github.com/kubernetes-sigs/metrics-server) in Kubernetes cluster.

This module aims to support most of the features provided by the official [Helm chart](https://github.com/kubernetes-sigs/metrics-server/tree/master/charts/metrics-server), including [addon-resizer](https://github.com/kubernetes/autoscaler/blob/master/addon-resizer/) support.

## Usage

### Basic
```hcl
module "metrics_server" {
  source  = "serhii-riabov/metrics-server/kubernetes"

  image_tag = "0.7.1" # Version of Metrics Server to deploy
}
```

### Advanced

#### HA setup
Example of usage for [HA setup](https://github.com/kubernetes-sigs/metrics-server?tab=readme-ov-file#high-availability):
```hcl
module "metrics_server" {
  source  = "serhii-riabov/metrics-server/kubernetes"

  image_tag                      = "0.7.1" # Version of Metrics Server to deploy
  deployment_replicas            = 2
  rolling_update_max_unavailable = 1
  pdb_enabled                    = true
  pdb_min_available              = 1
}
```

#### Usage with addon-resizer
Example of usage with addon-resizer sidecar:

```hcl
module "metrics_server" {
  source  = "serhii-riabov/metrics-server/kubernetes"

  image_tag             = "0.7.1" # Version of Metrics Server to deploy
  addon_resizer_enabled = true
}
```

#### Enabling ServiceMonitor
It is possible to enable ServiceMonitor creation for out-of-the-box metrics collection by in-cluster Prometheus. The module provides only basic configuration parameters for it. If you need advanced configuration for ServiceMonitor it is better to create it outside of this module.

Prometheus Operator CRDs can be natively managed with Terraform via [this module](https://registry.terraform.io/modules/serhii-riabov/prometheus-operator-crds/kubernetes/latest).
```hcl
module "metrics_server" {
  source  = "serhii-riabov/metrics-server/kubernetes"

  image_tag              = "0.7.1" # Version of Metrics Server to deploy
  servicemonitor_enabled = true
}
```

## Importing existing Metrics Server resources

It is possible to bring existing Metrics Server resources under Terraform management to avoid resource recreation. Starting with Terraform v1.5.0 and later it is possible to do this in a declarative way. Below is the code example.  

```hcl
# Resources for the basic deployment

import {
  to = module.metrics-server.kubernetes_api_service_v1.this
  id = "v1beta1.metrics.k8s.io"
}

import {
  to = module.metrics-server.kubernetes_cluster_role_binding_v1.metrics_server_system_auth_delegator[0]
  id = "metrics-server:system:auth-delegator"
}

import {
  to = module.metrics-server.kubernetes_cluster_role_binding_v1.system_metrics_server[0]
  id = "system:metrics-server"
}

import {
  to = module.metrics-server.kubernetes_cluster_role_v1.system_aggregated_metrics_reader[0]
  id = "system:metrics-server-aggregated-reader"
}

import {
  to = module.metrics-server.kubernetes_cluster_role_v1.system_metrics_server[0]
  id = "system:metrics-server"
}

import {
  to = module.metrics-server.kubernetes_deployment_v1.this
  id = "kube-system/metrics-server"
}

import {
  to = module.metrics-server.kubernetes_role_binding_v1.metrics_server_auth_reader[0]
  id = "kube-system/metrics-server-auth-reader"
}

import {
  to = module.metrics-server.kubernetes_service_account_v1.this
  id = "kube-system/metrics-server"
}

import {
  to = module.metrics-server.kubernetes_service_v1.this
  id = "kube-system/metrics-server"
}

# Additional resources if addon-resizer is enabled (addon_resizer_enabled = true)

import {
  to = module.metrics-server.kubernetes_config_map_v1.metrics_server_nanny_config[0]
  id = "kube-system/metrics-server-nanny-config"
}

import {
  to = module.metrics-server.kubernetes_role_v1.metrics_server_nanny[0]
  id = "kube-system/system:metrics-server-nanny"
}

import {
  to = module.metrics-server.kubernetes_role_binding_v1.metrics_server_nanny[0]
  id = "kube-system/metrics-server-nanny"
}

import {
  to = module.metrics-server.kubernetes_cluster_role_v1.system_metrics_server_nanny[0]
  id = "system:metrics-server-nanny"
}

import {
  to = module.metrics-server.kubernetes_cluster_role_binding_v1.system_metrics_server_nanny[0]
  id = "system:metrics-server-nanny"
}

# Additional resource if PDB is enabled (pdb_enabled = true)

import {
  to = module.metrics-server.kubernetes_pod_disruption_budget_v1.this[0]
  id = "kube-system/metrics-server"
}

# Additional resource if PSP is enabled (psp_enabled = true)

import {
  to = module.metrics-server.kubernetes_pod_security_policy_v1beta1.this[0]
  id = "privileged-metrics-server"
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.13 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_api_service_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/api_service_v1) | resource |
| [kubernetes_cluster_role_binding_v1.metrics_server_system_auth_delegator](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding_v1) | resource |
| [kubernetes_cluster_role_binding_v1.system_metrics_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding_v1) | resource |
| [kubernetes_cluster_role_binding_v1.system_metrics_server_nanny](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding_v1) | resource |
| [kubernetes_cluster_role_v1.system_aggregated_metrics_reader](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_v1) | resource |
| [kubernetes_cluster_role_v1.system_metrics_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_v1) | resource |
| [kubernetes_cluster_role_v1.system_metrics_server_nanny](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_v1) | resource |
| [kubernetes_config_map_v1.metrics_server_nanny_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_deployment_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment_v1) | resource |
| [kubernetes_manifest.service_monitor](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_pod_disruption_budget_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod_disruption_budget_v1) | resource |
| [kubernetes_pod_security_policy_v1beta1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod_security_policy_v1beta1) | resource |
| [kubernetes_role_binding_v1.metrics_server_auth_reader](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding_v1) | resource |
| [kubernetes_role_binding_v1.metrics_server_nanny](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding_v1) | resource |
| [kubernetes_role_v1.metrics_server_nanny](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_v1) | resource |
| [kubernetes_service_account_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |
| [kubernetes_service_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_annotations"></a> [additional\_annotations](#input\_additional\_annotations) | Additional annotations to attach to all resources | `map(string)` | `{}` | no |
| <a name="input_additional_args"></a> [additional\_args](#input\_additional\_args) | Additional command line arguments for Metrics Server | `list(string)` | `[]` | no |
| <a name="input_additional_labels"></a> [additional\_labels](#input\_additional\_labels) | Additional labels to attach to all resources | `map(string)` | `{}` | no |
| <a name="input_addon_resizer_enabled"></a> [addon\_resizer\_enabled](#input\_addon\_resizer\_enabled) | Enable Addon Resizer | `bool` | `false` | no |
| <a name="input_addon_resizer_image_repository"></a> [addon\_resizer\_image\_repository](#input\_addon\_resizer\_image\_repository) | Image Repository for Addon Resizer | `string` | `"registry.k8s.io/autoscaling/addon-resizer"` | no |
| <a name="input_addon_resizer_image_tag"></a> [addon\_resizer\_image\_tag](#input\_addon\_resizer\_image\_tag) | Image Tag for Addon Resizer | `string` | `"1.8.20"` | no |
| <a name="input_addon_resizer_nanny_cpu"></a> [addon\_resizer\_nanny\_cpu](#input\_addon\_resizer\_nanny\_cpu) | The base CPU resource requirement | `string` | `"0m"` | no |
| <a name="input_addon_resizer_nanny_extra_cpu"></a> [addon\_resizer\_nanny\_extra\_cpu](#input\_addon\_resizer\_nanny\_extra\_cpu) | The amount of CPU to add per node | `string` | `"1m"` | no |
| <a name="input_addon_resizer_nanny_extra_memory"></a> [addon\_resizer\_nanny\_extra\_memory](#input\_addon\_resizer\_nanny\_extra\_memory) | The amount of memory to add per node | `string` | `"2Mi"` | no |
| <a name="input_addon_resizer_nanny_memory"></a> [addon\_resizer\_nanny\_memory](#input\_addon\_resizer\_nanny\_memory) | The base memory resource requirement | `string` | `"0Mi"` | no |
| <a name="input_addon_resizer_nanny_min_cluster_size"></a> [addon\_resizer\_nanny\_min\_cluster\_size](#input\_addon\_resizer\_nanny\_min\_cluster\_size) | The smallest number of nodes resources will be scaled to | `number` | `100` | no |
| <a name="input_addon_resizer_nanny_poll_period"></a> [addon\_resizer\_nanny\_poll\_period](#input\_addon\_resizer\_nanny\_poll\_period) | The time, in milliseconds, to poll the dependent container | `number` | `300000` | no |
| <a name="input_addon_resizer_nanny_threshold"></a> [addon\_resizer\_nanny\_threshold](#input\_addon\_resizer\_nanny\_threshold) | Deviation from expected resources | `number` | `5` | no |
| <a name="input_addon_resizer_resource_limits"></a> [addon\_resizer\_resource\_limits](#input\_addon\_resizer\_resource\_limits) | Resource limits for Addon Resizer | <pre>object({<br>    cpu    = string<br>    memory = string<br>  })</pre> | <pre>{<br>  "cpu": "40m",<br>  "memory": "25Mi"<br>}</pre> | no |
| <a name="input_addon_resizer_resource_requests"></a> [addon\_resizer\_resource\_requests](#input\_addon\_resizer\_resource\_requests) | Resource requests for Addon Resizer | <pre>object({<br>    cpu    = string<br>    memory = string<br>  })</pre> | <pre>{<br>  "cpu": "40m",<br>  "memory": "25Mi"<br>}</pre> | no |
| <a name="input_api_service_annotations"></a> [api\_service\_annotations](#input\_api\_service\_annotations) | Annotations to attach to API Service | `map(string)` | `{}` | no |
| <a name="input_api_service_ca_bundle"></a> [api\_service\_ca\_bundle](#input\_api\_service\_ca\_bundle) | PEM encoded CA bundle which will be used to validate an API server's serving certificate | `string` | `null` | no |
| <a name="input_api_service_insecure_skip_tls_verify"></a> [api\_service\_insecure\_skip\_tls\_verify](#input\_api\_service\_insecure\_skip\_tls\_verify) | Specifies whether to skip TLS verification | `bool` | `true` | no |
| <a name="input_api_service_labels"></a> [api\_service\_labels](#input\_api\_service\_labels) | Labels to attach to API Service | `map(string)` | `{}` | no |
| <a name="input_args_override"></a> [args\_override](#input\_args\_override) | Overrides all command line arguments for Metrics Server | `list(string)` | `[]` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Container Port for Metrics Server | `number` | `10250` | no |
| <a name="input_deployment_annotations"></a> [deployment\_annotations](#input\_deployment\_annotations) | Annotations to attach to Deployment | `map(string)` | `{}` | no |
| <a name="input_deployment_labels"></a> [deployment\_labels](#input\_deployment\_labels) | Labels to attach to Deployment | `map(string)` | `{}` | no |
| <a name="input_deployment_replicas"></a> [deployment\_replicas](#input\_deployment\_replicas) | Number of Replicas | `number` | `1` | no |
| <a name="input_deployment_strategy"></a> [deployment\_strategy](#input\_deployment\_strategy) | Deployment Strategy | `string` | `"RollingUpdate"` | no |
| <a name="input_enable_service_links"></a> [enable\_service\_links](#input\_enable\_service\_links) | Enables generating environment variables for service discovery | `bool` | `false` | no |
| <a name="input_host_network_enabled"></a> [host\_network\_enabled](#input\_host\_network\_enabled) | Specifies if Metrics Server should be started in hostNetwork mode | `bool` | `null` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | Image Pull Policy | `string` | `"IfNotPresent"` | no |
| <a name="input_image_pull_secrets"></a> [image\_pull\_secrets](#input\_image\_pull\_secrets) | Image Pull Secrets | `list(string)` | `[]` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Image Repository | `string` | `"registry.k8s.io/metrics-server/metrics-server"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Image Tag | `string` | `"v0.7.0"` | no |
| <a name="input_name"></a> [name](#input\_name) | Application name | `string` | `"metrics-server"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace to deploy Metrics Server to | `string` | `"kube-system"` | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | Node selector | `map(string)` | `{}` | no |
| <a name="input_pdb_enabled"></a> [pdb\_enabled](#input\_pdb\_enabled) | Enable Pod Disruption Budget | `bool` | `false` | no |
| <a name="input_pdb_max_unavailable"></a> [pdb\_max\_unavailable](#input\_pdb\_max\_unavailable) | Absolute number or a percentage (mutually exclusive with pdb\_min\_available) | `string` | `null` | no |
| <a name="input_pdb_min_available"></a> [pdb\_min\_available](#input\_pdb\_min\_available) | Absolute number or a percentage (mutually exclusive with pdb\_max\_unavailable) | `string` | `null` | no |
| <a name="input_pod_annotations"></a> [pod\_annotations](#input\_pod\_annotations) | Annotations to attach to Pods | `map(string)` | `{}` | no |
| <a name="input_pod_labels"></a> [pod\_labels](#input\_pod\_labels) | Labels to attach to Pods | `map(string)` | `{}` | no |
| <a name="input_priority_class_name"></a> [priority\_class\_name](#input\_priority\_class\_name) | Priority Class Name | `string` | `"system-cluster-critical"` | no |
| <a name="input_psp_enabled"></a> [psp\_enabled](#input\_psp\_enabled) | Enable creation of Pod Security Policy | `bool` | `false` | no |
| <a name="input_rbac_create"></a> [rbac\_create](#input\_rbac\_create) | Specifies whether RBAC resources should be created | `bool` | `true` | no |
| <a name="input_resource_limits"></a> [resource\_limits](#input\_resource\_limits) | Resource limits | <pre>object({<br>    cpu    = string<br>    memory = string<br>  })</pre> | `null` | no |
| <a name="input_resource_requests"></a> [resource\_requests](#input\_resource\_requests) | Resource requests | <pre>object({<br>    cpu    = string<br>    memory = string<br>  })</pre> | <pre>{<br>  "cpu": "100m",<br>  "memory": "200Mi"<br>}</pre> | no |
| <a name="input_rolling_update_max_surge"></a> [rolling\_update\_max\_surge](#input\_rolling\_update\_max\_surge) | maxSurge parameter for Rolling Update | `string` | `"25%"` | no |
| <a name="input_rolling_update_max_unavailable"></a> [rolling\_update\_max\_unavailable](#input\_rolling\_update\_max\_unavailable) | maxUnavailable parameter for Rolling Update | `string` | `"25%"` | no |
| <a name="input_service_account_annotations"></a> [service\_account\_annotations](#input\_service\_account\_annotations) | Annotations to attach to Service Account | `map(string)` | `{}` | no |
| <a name="input_service_account_labels"></a> [service\_account\_labels](#input\_service\_account\_labels) | Labels to attach to Service Account | `map(string)` | `{}` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | If not specified, defaults to the Application Name | `string` | `""` | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | Service Annotations | `map(string)` | `{}` | no |
| <a name="input_service_labels"></a> [service\_labels](#input\_service\_labels) | Labels to attach to Service | `map(string)` | `{}` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | If not specified, defaults to the Application Name | `string` | `""` | no |
| <a name="input_servicemonitor_annotations"></a> [servicemonitor\_annotations](#input\_servicemonitor\_annotations) | Annotations to attach to ServiceMonitor | `map(string)` | `{}` | no |
| <a name="input_servicemonitor_enabled"></a> [servicemonitor\_enabled](#input\_servicemonitor\_enabled) | Create ServiceMonitor for Metrics Scraping | `bool` | `false` | no |
| <a name="input_servicemonitor_interval"></a> [servicemonitor\_interval](#input\_servicemonitor\_interval) | Scrape interval | `string` | `"1m"` | no |
| <a name="input_servicemonitor_labels"></a> [servicemonitor\_labels](#input\_servicemonitor\_labels) | Labels to attach to ServiceMonitor | `map(string)` | `{}` | no |
| <a name="input_servicemonitor_namespace"></a> [servicemonitor\_namespace](#input\_servicemonitor\_namespace) | If not set will be the same as for other resources | `string` | `""` | no |
| <a name="input_servicemonitor_scrape_timeout"></a> [servicemonitor\_scrape\_timeout](#input\_servicemonitor\_scrape\_timeout) | Scrape timeout | `string` | `"10s"` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | Tolerations | <pre>list(object({<br>    key                = string,<br>    operator           = string,<br>    value              = string,<br>    effect             = string,<br>    toleration_seconds = string<br>  }))</pre> | `[]` | no |
| <a name="input_whitelist_metrics_path"></a> [whitelist\_metrics\_path](#input\_whitelist\_metrics\_path) | Disable API Server authorization for /metrics path | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
