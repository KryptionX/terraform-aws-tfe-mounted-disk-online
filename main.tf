
# Pull in the base infrastructure from the Terrafrom Cloud workspace.

data "terraform_remote_state" "base-infra" {
  backend = "remote"

  config = {
    organization = "hashicorp-support-eng"
    workspaces = {
      name = "terraform-team-base-infrastructure"
    }
  }
}

# Set the data source for the base infrastructure to a local for ease of access

locals {
  base-infra = data.terraform_remote_state.base-infra.outputs
}

# Set up the AWS provider

provider "aws" {
  region = "us-east-1"
}

# Call the Terraform Enterprise module.

module "terraform-enterprise" {
  source  = "app.terraform.io/hashicorp-support-eng/terraform-enterprise/aws"
  version = "1.6.2"

  deployment_type                = "mounted-disk"
  license_url                    = local.base-infra.license_file
  vpc                            = local.base-infra.vpc
  zone_name                      = local.base-infra.zone_name
  release_sequence               = var.release_sequence
  os_type                        = var.os_type

}

output "application_url" {
  value = module.terraform-enterprise.application_url
}

output "replicated_dashboard" {
  value = module.terraform-enterprise.replicated_dashboard
}

output "initial_admin_user_link" {
  value = module.terraform-enterprise.initial_admin_user_link
}

output "tags" {
  value = module.terraform-enterprise.tags
}
