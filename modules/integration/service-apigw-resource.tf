#
# -- Data RESOURCE --

resource "aws_api_gateway_resource" "service_api" {
  rest_api_id = data.aws_api_gateway_rest_api.service_api.id
  parent_id   = data.aws_api_gateway_rest_api.service_api.root_resource_id
  path_part   = var.api_gateway.path
}

resource "aws_api_gateway_method" "any_service_api" {
  rest_api_id      = data.aws_api_gateway_rest_api.service_api.id
  resource_id      = aws_api_gateway_resource.service_api.id
  http_method      = "ANY"
  authorization    = var.api_gateway.auth_type
}

resource "aws_api_gateway_integration" "service_api" {
  rest_api_id = data.aws_api_gateway_rest_api.service_api.id
  resource_id = aws_api_gateway_method.any_service_api.resource_id
  http_method = aws_api_gateway_method.any_service_api.http_method
  type        = "AWS_PROXY"
  uri         = var.aws_lambda_api_handler.invoke_arn

  # AWS lambdas can only be invoked with the POST method
  integration_http_method = "POST"
}

#
# -- PROXY RESOURCE --

resource "aws_api_gateway_resource" "service_api_proxy" {
  rest_api_id = data.aws_api_gateway_rest_api.service_api.id
  parent_id   = aws_api_gateway_resource.service_api.id
  path_part   = "{proxy+}"
}


resource "aws_api_gateway_method" "any_service_api_proxy" {
  rest_api_id      = data.aws_api_gateway_rest_api.service_api.id
  resource_id      = aws_api_gateway_resource.service_api_proxy.id
  http_method      = "ANY"
  authorization    = var.api_gateway.auth_type
}

resource "aws_api_gateway_integration" "service_api_proxy" {
  rest_api_id = data.aws_api_gateway_rest_api.service_api.id
  resource_id = aws_api_gateway_method.any_service_api_proxy.resource_id
  http_method = aws_api_gateway_method.any_service_api_proxy.http_method
  type        = "AWS_PROXY"
  uri         = var.aws_lambda_api_handler.invoke_arn

  # AWS lambdas can only be invoked with the POST method
  integration_http_method = "POST"
}


# 
# -- OPTIONS METHOD (Required for CORS)
#
resource "aws_api_gateway_method" "options" {
  rest_api_id   = data.aws_api_gateway_rest_api.service_api.id
  resource_id   = aws_api_gateway_resource.service_api_proxy.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = data.aws_api_gateway_rest_api.service_api.id
  resource_id = aws_api_gateway_resource.service_api_proxy.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = 200

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }

  depends_on = [aws_api_gateway_method.options]
}

resource "aws_api_gateway_integration" "options" {
  rest_api_id = data.aws_api_gateway_rest_api.service_api.id
  resource_id = aws_api_gateway_resource.service_api_proxy.id
  http_method = aws_api_gateway_method.options.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  depends_on = [aws_api_gateway_method.options]
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = data.aws_api_gateway_rest_api.service_api.id
  resource_id = aws_api_gateway_resource.service_api_proxy.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,DELETE,GET,HEAD,PATCH,POST,PUT'"
  }

  response_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  depends_on = [
    aws_api_gateway_method_response.options_200,
    aws_api_gateway_integration.options,
  ]
}
