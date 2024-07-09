variable "cluster_name" {
  description = "OpenShift cluster name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}