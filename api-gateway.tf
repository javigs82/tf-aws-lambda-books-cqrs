module "api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "2.2.1"

  name          = var.cmp_name
  description   = "API Gateway ${var.cmp_name}"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  create_api_domain_name = false

  integrations = {
    "ANY /" = {
      lambda_arn             = module.lambda_query.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "$default" = {
      lambda_arn = module.lambda_query.lambda_function_arn
    }
  }

  tags = {
    Name = var.cmp_name
  }
}