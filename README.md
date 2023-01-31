# Deploy Equinix Metal hosts using Terraform

This is a quick start that I used to deploy a host in Equinix Metal, in order to run a portable environment for containerized applications.

## What does it do?

This repo is intended to be a starting point, to launch a bare metal node in the Equinix Metal console using the Terraform service provider. This project assumes that an authentication token has been created in the console, and then encrypted using SOPS in the `vars.enc.json` file. This allows us to encrypt secrets at rest, and use Terragrunt hooks to decrypt and encrypt on the fly as we deploy or interact with the API.

Once this has been setup, I use the Equinix Metal Terraform module to set some parameters with default values. I then created the `equinix-metal` folder that utilizes this Terraform module, and sets us up to be able to scale if we wanted more nodes.

Once the Terraform has been applied, we are left with a node running in the Equinix Metal console, and an elastic IP assigned. My intention was to use this node to run containerized applications, or to natively run applications that can use mutliple regions for redundancy and availability.

### Resources

- https://deploy.equinix.com/metal/
- https://www.terraform.io/
- https://registry.terraform.io/providers/equinix/equinix/latest/docs
- https://github.com/mozilla/sops
- https://terragrunt.gruntwork.io/