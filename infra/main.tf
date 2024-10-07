# Primary Resource: s3 Bucket
resource "aws_s3_bucket" "main" {
  bucket = local.s3_bucket_name
}

# Primary Resource: Cloudfront Distribution
resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  aliases             = [local.domain]
  is_ipv6_enabled     = true
  wait_for_deployment = true
  default_root_object = "index.html"

  # Defining the behaviour of cache of cloudfront
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html
    target_origin_id       = aws_s3_bucket.main.bucket
    viewer_protocol_policy = "redirect-to-https"
  }

  # The origin is where our content is coming from
  # In this case this is the s3 bucket we created earlier
  origin {
    domain_name              = aws_s3_bucket.main.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
    origin_id                = aws_s3_bucket.main.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # The cert we created for our domain
  viewer_certificate {
    acm_certificate_arn      = local.cert_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  tags = {
    Environment = "crc-cloudfront"
  }
}

# This is to set the origin of the cloudfront distribution. Here it is only s3
resource "aws_cloudfront_origin_access_control" "main" {
  name                              = local.cloudfront_oac_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_iam_policy_document" "cloudfront-oac-access" {
  statement {
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]

    condition {
      test     = "StringEquals"
      values   = [aws_cloudfront_distribution.main.arn]
      variable = "AWS:SourceArn"
    }
  }
}

# Defining the policy for s3 bucket so that only cloudfront can access the contents
resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.cloudfront-oac-access.json
}

# Creating a record for our subdomain name to that we can access it over route53
resource "aws_route53_record" "main" {
  name    = local.domain
  type    = "A"
  zone_id = local.hosted_zone_id

  # This essentially does this
  # End User --> Route 53 [--> Cloudfront Domain --> s3 bucket]
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
  }
}

# Serverless Part:
# API Gateway -> Lambda -> DynamoDB
# DynamoDB
resource "aws_dynamodb_table" "visitor-count-db" {
  name         = "resumeVisitorTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "visitors"
    type = "N"
  }

  global_secondary_index {
    name            = "visitors-count"
    hash_key        = "visitors"
    projection_type = "ALL"
    read_capacity   = 1
    write_capacity  = 1
  }

  tags = {
    Name = "CRC-AWS"
  }
}

# Adding default item
resource "aws_dynamodb_table_item" "visitor-count-db" {
  table_name = aws_dynamodb_table.visitor-count-db.name
  hash_key   = aws_dynamodb_table.visitor-count-db.hash_key

  item = jsonencode(
    {
      "id" : { "S" : "visitors-count" },
      "visitors" : { "N" : "1" }
    }
  )
}

# Lambda 
# Creation of IAM Role for lambda function
resource "aws_iam_role" "lambda_role" {
  name = "aws-resume-lambda-role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
        }
      ]
    }
  )
}

# Retrieve the current AWS region dynamically
data "aws_region" "current" {}

# Retrieve the current AWS account ID dynamically
data "aws_caller_identity" "current" {}

# Creation of IAM Policy for Lambda function to access dynamoDB
resource "aws_iam_policy" "dynamoDB-lambda-role-policy" {
  name        = "dynamoDB-lambda-role-policy"
  path        = "/"
  description = "AWS IAM Policy for Lambda to Access Dynamo DB"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:GetItem",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:PutItem",
            "dynamodb:UpdateItem"
          ],
          "Resource" : "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
        }
      ]
    }
  )
}

# IAM Policy attachment
resource "aws_iam_role_policy_attachment" "attach-policy-to-role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.dynamoDB-lambda-role-policy.arn
}

# Zip file
data "archive_file" "zip-code" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/"
  output_path = "${path.module}/lambda/lambda_func.zip"
}

# handler
resource "aws_lambda_function" "lambda_handler" {
  function_name = "visitor-count-handler"

  filename   = "${path.module}/lambda/lambda_func.zip"
  role       = aws_iam_role.lambda_role.arn
  handler    = "lambda_function.lambda_handler"
  runtime    = "python3.8"
  depends_on = [aws_iam_role_policy_attachment.attach-policy-to-role]
  environment {
    variables = {
      databaseName = "resumeVisitorTable"
    }
  }
}

# API Gateway for lambda function handling
resource "aws_apigatewayv2_api" "visitor-count-api" {
  name          = "visitor-count-api"
  protocol_type = "HTTP"
  description   = "POST API to update visitor count"

  cors_configuration {
    allow_credentials = false
    allow_headers     = []
    allow_origins = [
      "*",
    ]
    allow_methods = [
      "GET",
    "POST"]
    max_age = 0
  }
}

# API Gateway Stage
resource "aws_apigatewayv2_stage" "init" {
  api_id      = aws_apigatewayv2_api.visitor-count-api.id
  name        = "init"
  auto_deploy = true
}

# API Gateway Integration
resource "aws_apigatewayv2_integration" "visitor-count-api-integration" {
  api_id             = aws_apigatewayv2_api.visitor-count-api.id
  integration_uri    = aws_lambda_function.lambda_handler.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

# Routing queries from a public exposed url to lambda function
resource "aws_apigatewayv2_route" "visitor-count-api-route" {
  api_id    = aws_apigatewayv2_api.visitor-count-api.id
  route_key = "ANY /countVisitors"
  target    = "integrations/${aws_apigatewayv2_integration.visitor-count-api-integration.id}"
}

# Setting permission to invoke lambda function from
resource "aws_lambda_permission" "api-gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_handler.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.visitor-count-api.execution_arn}/*"
}

output "apigw-public-url" {
  value = "${aws_apigatewayv2_stage.init.invoke_url}/countVisitors"
}

output "cloudfront-distribution-id" {
  value = "${aws_cloudfront_distribution.main.id}"
}
