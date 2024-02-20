###################################################################################
# AWS Virtual Private Cloud (VPC) Container Network Interface (CNI) Configuration #
###################################################################################

variable "aws_vpc_cni_branch_eni_cooldown" {
  default     = 60
  description = "Time to Wait Before Making ENI Changes (in Seconds)"
  type        = number
}

variable "aws_vpc_cni_enable_network_policy_controller" {
  default     = false
  description = "'true' if Network Policy Controller Should be Enabled"
  type        = bool
}

variable "aws_vpc_cni_enable_windows_ipam" {
  default     = false
  description = "'true' if Windows Node IP Management Should be Enabled"
  type        = bool
}

variable "aws_vpc_cni_enable_windows_prefix_delegation" {
  default     = false
  description = "'true' if an IP CIDR Prefix Should be Assigned to Each Node"
  type        = bool
}

variable "aws_vpc_cni_minimum_ip_target" {
  default     = 3
  description = "Minumum Number of IP Addresses to Make Available for Pods on Each Node"
  type        = number
}

variable "aws_vpc_cni_warm_ip_target" {
  default     = 1
  description = "Total Number of Unassigned IP Addresses to Keep Available for Pods on Each Node"
  type        = number
}

variable "aws_vpc_cni_warm_prefix_target" {
  default     = 0
  description = "Total Number of Warn IP CIDR Prefix Addresses to Keep Assigned to Each Node"
  type        = number
}
