variable "cluster_name" {
  description = "The name of the EKS cluster to which the addon will be added."
  type        = string
}

variable "matrix_server_version" {
  description = "The version of the metrics-server addon to use. If not specified, the most recent version will be used."
  type        = string
  default     = null
}