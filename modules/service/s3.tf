# 
# S3 Bucket for storing Lambdas Zip
#  
data "aws_s3_bucket" "lambda_packages" {
  bucket = "${var.env}-enterprise-storage-lambda-packages-${var.region}-${var.account_id}"
}
