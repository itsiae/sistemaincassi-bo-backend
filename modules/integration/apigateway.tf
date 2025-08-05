data "aws_api_gateway_rest_api" "service_api" {
  name = var.api_gateway.name
}

resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = var.aws_lambda_api_handler.arn
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${data.aws_api_gateway_rest_api.service_api.execution_arn}/*/*/*"

  depends_on = [
    aws_api_gateway_resource.service_api_proxy
  ]
}
