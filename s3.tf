## creating bucket

resource "aws_s3_bucket" "logs" {
  bucket = local.bucket_name
  tags = {
    "ProjectName" = var.project_name
    "Environment" = var.env
  }
}

resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  index_document {
    suffix = local.index_file
  }

  error_document {
    key = local.error_file
  }
}


resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id

  depends_on = [
    aws_s3_bucket_public_access_block.logs,
    aws_s3_bucket_ownership_controls.logs
  ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPublicReadForWebsite"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.logs.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = local.bucket_versioning_status
  }

}

resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}/Registration", "**")
  bucket   = aws_s3_bucket.logs.id
  key      = each.value
  source   = "${path.module}/Registration/${each.value}"

  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "gif"  = "image/gif"
  }, lower(split(".", each.value)[length(split(".", each.value)) - 1]), "text/plain")

  etag = filemd5("${path.module}/Registration/${each.value}")
}

resource "aws_s3_object" "deployment_version" {
  bucket = aws_s3_bucket.logs.id
  key    = "deployment-version.txt"

  content = <<EOF
Deployment Metadata
===================
Bucket: ${aws_s3_bucket.logs.bucket}
Deployed At: ${timestamp()}

Files & Version IDs
-------------------
${join("\n", [
  for file, obj in aws_s3_object.website_files :
  "${file} => ${obj.version_id}"
])}
EOF

content_type = "text/plain"

depends_on = [
  aws_s3_object.website_files
]
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.logs.website_endpoint
}
