resource "aws_lambda_function" "service_api_handler" {
  function_name = local.function_name

  s3_bucket        = aws_s3_object.lambda_zip_build.bucket
  s3_key           = aws_s3_object.lambda_zip_build.key
  source_code_hash = data.archive_file.source.output_md5

  runtime       = var.lambda.lambda_runtime
  memory_size   = var.lambda.lambda_memory
  architectures = ["arm64"]
  handler       = "dist/index.handler"
  timeout       = var.lambda.lambda_timeout

  role = aws_iam_role.service_api_handler.arn

  vpc_config {
    subnet_ids = [
      data.aws_subnet.server_a.id,
      data.aws_subnet.server_b.id,
      data.aws_subnet.server_c.id
    ]
    security_group_ids = [
      data.aws_security_group.egress_everywhere.id,
    ]
  }

  environment {
    variables = {
      LOG_LEVEL     = var.lambda.environments.log_level
      PATH_PREFIX   = var.lambda.environments.api_path
      SERVICE_NAME  = var.lambda.environments.lambda_service_name
      NAMESPACE     = var.lambda.environments.lambda_namespace
    }
  }

  depends_on = [aws_s3_object.lambda_zip_build]
}

#
# IAM Role for Lambda function
#
resource "aws_iam_role" "service_api_handler" {
  name = local.prefix

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow"
      }
    ]
  })

  inline_policy {
    name = "put-xray-tracing"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect   = "Allow",
          Action   = ["xray:PutTraceSegments", "xray:PutTelemetryRecords"],
          Resource = "*",
        },
      ],
    })
  }

}

# Lambda Basics Policy (Cloudwatch logs)
resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.service_api_handler.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda VPC Access
resource "aws_iam_role_policy_attachment" "vpc_access" {
  role       = aws_iam_role.service_api_handler.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

#
# Lambda Build and Upload to S3
#
resource "null_resource" "build_package" {
  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/lambda"
    command     = "yarn --frozen-lockfile --mutex network"
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/lambda"
    command     = "yarn build"
  }
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/dist"
  output_path = "${path.module}/lambda.zip"

  depends_on = [null_resource.build_package]
}

resource "aws_s3_object" "lambda_zip_build" {
  bucket = data.aws_s3_bucket.lambda_packages.id
  key    = "${var.project}/${local.function_name}.zip"
  source = data.archive_file.source.output_path
  etag   = data.archive_file.source.output_md5

  depends_on = [data.archive_file.source]
}

# -------------- Cloudwatch Log Group --------------
resource "aws_cloudwatch_log_group" "organize_bronze_layer" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = var.cloudwatch.logs_retention_days
}
