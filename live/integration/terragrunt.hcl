include {
  path   = find_in_parent_folders()
}

locals {
  module    = basename(get_terragrunt_dir())
  config    = yamldecode(file(find_in_parent_folders("config.yaml")))
  stage     = yamldecode(file("../_envs/${get_env("ENV")}.yaml"))
  manifest  = yamldecode(file("../../chart/Chart.yaml"))
}

dependency "service" {
  config_path   = find_in_parent_folders("service")
  mock_outputs  = {
    aws_lambda_api_handler = {
      invoke_arn  = "mock"
      arn  = "mock"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs_merge_with_state = contains(["init", "validate", "plan"], get_terraform_command()) ? true : false
}


inputs = {
  account_id              = get_aws_account_id()
  region                  = local.config.region.primary
  project                 = local.config.project_name
  env                     = local.stage.env
  module                  = local.module

  api_gateway             = local.stage.integration.api_gateway
  app_version             = local.manifest.appVersion

  aws_lambda_api_handler  = dependency.service.outputs.aws_lambda_api_handler
}
