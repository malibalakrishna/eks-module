variable "cluster_name" { type = string }
variable "cluster_version" { type = string # e.g., "1.30"
validation {
condition = can(regex("^1\\.(2[0-9]|3[0-1])$", var.cluster_version))
error_message = "Provide a supported EKS version string, e.g. 1.29 or 1.30."
}
}


variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }


variable "instance_types" {
type = list(string)
default = ["t3.large"]
}


variable "capacity_type" {
type = string
default = "ON_DEMAND" # or "SPOT"
}


variable "tags" {
type = map(string)
default = {}
}


# Cluster Autoscaler settings
variable "enable_cluster_autoscaler" { type = bool, default = true }
variable "cluster_autoscaler_chart_version" { type = string, default = "9.44.0" }
