# * Module Output Variables to other modules or stdout
# * ---------------------------------------------------
output "aws_lambda_api_handler" {
  value     = aws_lambda_function.service_api_handler
  sensitive = true
}
