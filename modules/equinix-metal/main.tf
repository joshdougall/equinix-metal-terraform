provider "equinix" {
  auth_token = var.equinix_metal_auth_token
}

terraform {
  required_providers {
    metal = {
      source  = "equinix/equinix"
      version = "1.11.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1.2"
    }
  }
}

resource "equinix_metal_device" "equinix_metal_node" {
  count = var.node_count

  hostname         = var.hostname
  plan             = var.device_type
  facilities       = [var.facility]
  operating_system = var.equinix_metal_os
  billing_cycle    = "hourly"
  project_id       = var.project_id
}

resource "equinix_metal_reserved_ip_block" "equinix_metal_block" {
  project_id = var.project_id
  facility   = var.facility
  quantity   = var.node_count
}

resource "equinix_metal_ip_attachment" "equinix_metal_node_assignment" {
  count = var.node_count

  device_id = equinix_metal_device.equinix_metal_node[count.index].id
  cidr_notation = join("/", [cidrhost(equinix_metal_reserved_ip_block.equinix_metal_block.cidr_notation, 0), "32"])
}

resource "null_resource" "elastic_setup" {
  count = var.node_count
  depends_on = [equinix_metal_ip_attachment.equinix_metal_node_assignment]

  connection {
    type = "ssh"
    private_key = file("~/.ssh/id_ed25519")
    user = var.ssh_user
    host = equinix_metal_device.equinix_metal_node[count.index].access_public_ipv4
  }

  provisioner "remote-exec" {
    inline = [<<EOF
      echo "network:" | tee -a /etc/netplan/00-elastic.yaml &&
      echo "  version: 2" | tee -a /etc/netplan/00-elastic.yaml &&
      echo "  renderer: networkd" | tee -a /etc/netplan/00-elastic.yaml &&
      echo "  ethernets:" | tee -a /etc/netplan/00-elastic.yaml &&
      echo "    lo:" | tee -a /etc/netplan/00-elastic.yaml &&
      echo "      addresses:" | tee -a /etc/netplan/00-elastic.yaml &&
      echo "        - 127.0.0.1/8" | tee -a /etc/netplan/00-elastic.yaml &&
      echo "        - ${equinix_metal_ip_attachment.equinix_metal_node_assignment[count.index].cidr_notation}" | tee -a /etc/netplan/00-elastic.yaml &&
      netplan apply
    EOF
    ]
  }
}

output "node_elastic_ip" {
  value = equinix_metal_ip_attachment.equinix_metal_node_assignment.*.address
}

output "node_public_management_ip" {
  value = equinix_metal_device.equinix_metal_node.*.access_public_ipv4
}