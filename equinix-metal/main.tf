terraform {
  required_version = "~> 1.0.0"
  backend "gcs" {}
}

variable "environment" {}
variable "project_id" {}
variable "project_name" {}
variable "folder_id" {}
variable "hostname" {
  default = ""
}
variable "facility" {
  default = ""
}
variable "node_count" {
  default = ""
}
variable "metal_auth_token" {}
variable "device_type" {
  default = ""
}
variable "metal_os" {
  default = ""
}
variable "location" {}

module "equinix-metal-host-1" {
  source = "../modules/equinix-metal"

  metal_auth_token = var.metal_auth_token
  project_id       = var.project_id
  node_count       = 1
  facility         = "ny5"
  environment      = "equinix-metal-demo"
  metal_os         = "ubuntu_20_04"
  device_type      = "c3.small.x86"
  hostname         = "equinix-metal-host-1"
}

  
## Outputs

output "equinix_metal_node_management_ip" {
  value = module.equinix-metal-host-1.node_public_management_ip
}

output "equinix_metal_node_elastic_ip" {
  value = module.equinix-metal-host-1.node_elastic_ip
}