resource "null_resource" "create_deployment" {
  depends_on = [
    aws_lambda_permission.allow_api_gateway
  ]

  provisioner "local-exec" {
    command = <<EOT
      echo "=== Creating new deployment ==="
    EOT
  }

  provisioner "local-exec" {
    command = "aws apigateway create-deployment --rest-api-id ${data.aws_api_gateway_rest_api.service_api.id} --stage-name ${var.env}"
  }


  provisioner "local-exec" {
    command = <<EOT
      echo "✅ Deployment created!"
    EOT
  }

  triggers = {
    always_run = "${var.app_version}"
  }
}
