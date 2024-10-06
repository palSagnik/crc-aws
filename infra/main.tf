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
}

# This is to set the origin of the cloudfront distribution. Here it is only s3
resource "aws_cloudfront_origin_access_control" "main" {
  name                              = "s3-cloudfront-crc-oac"
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

resource "aws_dynamodb_table" "visitor-count-db" {
  name = "resumeVisitorTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "visitor"
    type = "N"
  }

  
  
}