variable "equinix_metal_auth_token" {
  description = "Equinix Metal user api token"
  type        = string
}

variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "environment" {
  type        = string
}

variable "hostname" {
  type        = string
}

variable "node_count" {
  description = "Number of equinix metal nodes"
  type        = number
  default     = 1
}
variable "facility" {
  description = "Packet facility to provision in"
  type        = string
}

variable "device_type" {
  type        = string
  description = "Type of device to provision"
}

variable "equinix_metal_os" {
  type        = string
  description = "Operating system to use on the equinix metal nodes"
  default     = "ubuntu_20_04"
}

variable "ssh_user" {
  description = "Username that will be used to transfer files from your local environment to the equinix metal node(s)"
  type        = string
  default     = "root"
}