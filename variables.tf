variable "name" {
  description = "Application name"
  type        = string
  default     = "metrics-server"
}

variable "namespace" {
  description = "Namespace to deploy Metrics Server to"
  type        = string
  default     = "kube-system"
}

variable "image_repository" {
  description = "Image Repository"
  type        = string
  default     = "registry.k8s.io/metrics-server/metrics-server"
}

variable "image_tag" {
  description = "Image Tag"
  type        = string
  default     = "v0.7.0"
}

variable "image_pull_policy" {
  description = "Image Pull Policy"
  type        = string
  default     = "IfNotPresent"
}

variable "image_pull_secrets" {
  description = "Image Pull Secrets"
  type        = list(string)
  default     = []
}

variable "additional_labels" {
  description = "Additional labels to attach to all resources"
  type        = map(string)
  default     = {}
}

variable "additional_annotations" {
  description = "Additional annotations to attach to all resources"
  type        = map(string)
  default     = {}
}

variable "rbac_create" {
  description = "Specifies whether RBAC resources should be created"
  type        = bool
  default     = true
}

variable "api_service_insecure_skip_tls_verify" {
  description = "Specifies whether to skip TLS verification"
  type        = bool
  default     = true
}

variable "api_service_ca_bundle" {
  description = "PEM encoded CA bundle which will be used to validate an API server's serving certificate"
  type        = string
  default     = null
}

variable "api_service_labels" {
  description = "Labels to attach to API Service"
  type        = map(string)
  default     = {}
}

variable "api_service_annotations" {
  description = "Annotations to attach to API Service"
  type        = map(string)
  default     = {}
}

variable "service_account_name" {
  description = "If not specified, defaults to the Application Name"
  type        = string
  default     = ""
}

variable "service_account_labels" {
  description = "Labels to attach to Service Account"
  type        = map(string)
  default     = {}
}

variable "service_account_annotations" {
  description = "Annotations to attach to Service Account"
  type        = map(string)
  default     = {}
}

variable "service_name" {
  description = "If not specified, defaults to the Application Name"
  type        = string
  default     = ""
}

variable "service_labels" {
  description = "Labels to attach to Service"
  type        = map(string)
  default     = {}
}

variable "service_annotations" {
  description = "Service Annotations"
  type        = map(string)
  default     = {}
}

variable "deployment_replicas" {
  description = "Number of Replicas"
  type        = number
  default     = 1
}

variable "deployment_strategy" {
  description = "Deployment Strategy"
  type        = string
  default     = "RollingUpdate"
}

variable "rolling_update_max_surge" {
  description = "maxSurge parameter for Rolling Update"
  type        = string
  default     = "25%"
}

variable "rolling_update_max_unavailable" {
  description = "maxUnavailable parameter for Rolling Update"
  type        = string
  default     = "25%"
}

variable "deployment_labels" {
  description = "Labels to attach to Deployment"
  type        = map(string)
  default     = {}
}

variable "deployment_annotations" {
  description = "Annotations to attach to Deployment"
  type        = map(string)
  default     = {}
}

variable "additional_args" {
  description = "Additional command line arguments for Metrics Server"
  type        = list(string)
  default     = []
}

variable "args_override" {
  description = "Overrides all command line arguments for Metrics Server"
  type        = list(string)
  default     = []
}

variable "host_network_enabled" {
  description = "Specifies if Metrics Server should be started in hostNetwork mode"
  type        = bool
  default     = null
}

variable "priority_class_name" {
  description = "Priority Class Name"
  type        = string
  default     = "system-cluster-critical"
}

variable "resource_requests" {
  description = "Resource requests"
  type = object({
    cpu    = string
    memory = string
  })
  default = {
    cpu    = "100m"
    memory = "200Mi"
  }
}

variable "resource_limits" {
  description = "Resource limits"
  type = object({
    cpu    = string
    memory = string
  })
  default = null
}

variable "container_port" {
  description = "Container Port for Metrics Server"
  type        = number
  default     = 10250
}

variable "pod_labels" {
  description = "Labels to attach to Pods"
  type        = map(string)
  default     = {}
}

variable "pod_annotations" {
  description = "Annotations to attach to Pods"
  type        = map(string)
  default     = {}
}

variable "whitelist_metrics_path" {
  description = "Disable API Server authorization for /metrics path"
  type        = bool
  default     = false
}

variable "psp_enabled" {
  description = "Enable creation of Pod Security Policy"
  type        = bool
  default     = false
}

variable "pdb_enabled" {
  description = "Enable Pod Disruption Budget"
  type        = bool
  default     = false
}

variable "pdb_min_available" {
  description = "Absolute number or a percentage (mutually exclusive with pdb_max_unavailable)"
  type        = string
  default     = null
}

variable "pdb_max_unavailable" {
  description = "Absolute number or a percentage (mutually exclusive with pdb_min_available)"
  type        = string
  default     = null
}

variable "enable_service_links" {
  description = "Enables generating environment variables for service discovery"
  type        = bool
  default     = false
}

variable "node_selector" {
  description = "Node selector"
  type        = map(string)
  default     = {}
}

variable "tolerations" {
  description = "Tolerations"
  type = list(object({
    key                = string,
    operator           = string,
    value              = string,
    effect             = string,
    toleration_seconds = string
  }))
  default = []
}

variable "addon_resizer_enabled" {
  description = "Enable Addon Resizer"
  type        = bool
  default     = false
}

variable "addon_resizer_image_repository" {
  description = "Image Repository for Addon Resizer"
  type        = string
  default     = "registry.k8s.io/autoscaling/addon-resizer"
}

variable "addon_resizer_image_tag" {
  description = "Image Tag for Addon Resizer"
  type        = string
  default     = "1.8.20"
}

variable "addon_resizer_resource_requests" {
  description = "Resource requests for Addon Resizer"
  type = object({
    cpu    = string
    memory = string
  })
  default = {
    cpu    = "40m"
    memory = "25Mi"
  }
}

variable "addon_resizer_resource_limits" {
  description = "Resource limits for Addon Resizer"
  type = object({
    cpu    = string
    memory = string
  })
  default = {
    cpu    = "40m"
    memory = "25Mi"
  }
}

variable "addon_resizer_nanny_cpu" {
  description = "The base CPU resource requirement"
  type        = string
  default     = "0m"
}

variable "addon_resizer_nanny_extra_cpu" {
  description = "The amount of CPU to add per node"
  type        = string
  default     = "1m"
}

variable "addon_resizer_nanny_memory" {
  description = "The base memory resource requirement"
  type        = string
  default     = "0Mi"
}

variable "addon_resizer_nanny_extra_memory" {
  description = "The amount of memory to add per node"
  type        = string
  default     = "2Mi"
}

variable "addon_resizer_nanny_min_cluster_size" {
  description = "The smallest number of nodes resources will be scaled to"
  type        = number
  default     = 100
}

variable "addon_resizer_nanny_poll_period" {
  description = "The time, in milliseconds, to poll the dependent container"
  type        = number
  default     = 300000
}

variable "addon_resizer_nanny_threshold" {
  description = "Deviation from expected resources"
  type        = number
  default     = 5
}

variable "servicemonitor_enabled" {
  description = "Create ServiceMonitor for Metrics Scraping"
  type        = bool
  default     = false
}

variable "servicemonitor_namespace" {
  description = "If not set will be the same as for other resources"
  type        = string
  default     = ""
}

variable "servicemonitor_labels" {
  description = "Labels to attach to ServiceMonitor"
  type        = map(string)
  default     = {}
}

variable "servicemonitor_annotations" {
  description = "Annotations to attach to ServiceMonitor"
  type        = map(string)
  default     = {}
}

variable "servicemonitor_interval" {
  description = "Scrape interval"
  type        = string
  default     = "1m"
}

variable "servicemonitor_scrape_timeout" {
  description = "Scrape timeout"
  type        = string
  default     = "10s"
}
