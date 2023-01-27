variable "allow_virtual_network_access" {
  description = "Controls if the VMs in the remote virtual network can access VMs in the local virtual network"
  default     = true
}

variable "allow_forwarded_traffic" {
  description = "Controls if forwarded traffic from VMs in the remote virtual network is allowed"
  default     = true
}