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

variable "vpc" {
  type = object({
    stage: string
    security_group: string
  })
}

variable "module" {
  description = "The terragrunt module's name"
  type        = string
}

variable "cloudwatch" {
  description = "Retention for application logs, configured based on environment"
  type = object({
    logs_retention_days: number
  })
}

variable "lambda" {
  type = object({
    lambda_memory       = number
    lambda_timeout      = number
    lambda_runtime      = string
    environments        = object({
      log_level           = string
      api_path            = string
      lambda_namespace    = string
      lambda_service_name = string
    })
  })
}
