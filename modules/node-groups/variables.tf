variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the node groups will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the node groups will be created"
  type        = list(string)
}

variable "node_groups" {
  description = "Map of EKS managed node group definitions"
  type = map(object({
    name           = string
    instance_types = list(string)
    capacity_type  = string
    ami_type      = string
    disk_size     = number
    min_size      = number
    max_size      = number
    desired_size  = number
    
    update_config = object({
      max_unavailable_percentage = number
      max_surge                 = number
    })
    
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
    
    labels = map(string)
  }))
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}