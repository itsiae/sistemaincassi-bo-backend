include {
  path = find_in_parent_folders()
}

locals {
  module = basename(get_terragrunt_dir())
  config = yamldecode(file(find_in_parent_folders("config.yaml")))
  stage  = yamldecode(file("../_envs/${get_env("ENV")}.yaml"))
}

inputs = {
  # module configuration variables
  account_id = get_aws_account_id()
  region     = local.config.region.primary
  project    = local.config.project_name
  env        = local.stage.env
  vpc        = local.stage.service.vpc
  module     = local.module

  cloudwatch = local.stage.service.cloudwatch
  lambda     = local.stage.service.lambda
}
