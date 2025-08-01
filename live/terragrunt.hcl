locals {
  config = yamldecode(file(find_in_parent_folders("config.yaml")))
  stage  = yamldecode(file("_envs/${get_env("ENV")}.yaml"))

  global_tags = { for t in local.config.tags: t.key => t.value } 
  stage_tags  = { for t in local.stage.tags: t.key => t.value } 
  
  // Final default tags
  default_tags = merge(local.global_tags, local.stage_tags)
}

remote_state {
  backend = "s3"
  config = {
    encrypt             = true
    bucket              = "${local.stage.env}-${local.config.repository_name}-terraform-state"
    key                 = "${path_relative_to_include()}/terraform.tfstate"
    region              = local.config.region.primary
    dynamodb_table      = "${local.stage.env}-${local.config.repository_name}-terraform-state"
    s3_bucket_tags      = local.default_tags
    dynamodb_table_tags = local.default_tags
  }
}

terraform {
  source = "${path_relative_from_include()}/../modules/${path_relative_to_include()}"
}

// Inputs for the Provider
inputs = {
    default_tags = local.default_tags
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF

  variable default_tags {
    type = map
    default = {}
  }

  provider "aws" {
    region = "${local.config.region.primary}"
    default_tags {
      tags = var.default_tags
    }
  }
  
  EOF
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  terraform {
    backend "s3" {}
  }
  EOF
}
