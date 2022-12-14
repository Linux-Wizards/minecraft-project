variable "tenancy_ocid" {
  description = "OCID of the tenancy"
  type        = string
}

variable "name" {
  description = "Display name for resources"
  type        = string
  default     = "OCI Free Minecraft"
}

variable "cidr_block" {
  description = "CIDR block of the VCN"
  type        = string
  default     = "10.10.10.0/24"

  validation {
    condition     = can(cidrsubnets(var.cidr_block, 2))
    error_message = "The value of cidr_block variable must be a valid CIDR address with a prefix no greater than 30."
  }
}

variable "ssh_public_key" {
  description = "Public key to be used for SSH access to compute instances"
  type        = string
}
