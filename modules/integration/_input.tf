# * Module Input Variables from other modules and from config
# * ----------------------------------------------------------

variable "account_id" {
  description = "The AWS Account number used for deploying Terraform"
  type        = string
}

variable "region" {
  description = "Primary AWS Region to be used"
  type        = string
}

variable "project" {
  description = "The Project Name"
  type        = string
}

variable "env" {
  description = "The current environment"
  type        = string
}

variable "module" {
  description = "The terragrunt module's name"
  type        = string
}

variable "api_gateway" {
  type = object({
    name      = string
    path      = string
    auth_type = string
  })
}


variable "aws_lambda_api_handler" {
  description = "The lambda service"
  type = object({
    invoke_arn = string
    arn        = string
  })
}

variable "app_version" {
  description = "Manifest app version"
  type        = string
}
