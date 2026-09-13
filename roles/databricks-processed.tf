resource "aws_iam_role_policy" "databricks_s3" {
  name = "databricks-housing-s3-policy"
  role = aws_iam_role.databricks_processed.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::housing-intelligence-data"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::housing-intelligence-data/processed/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "databricks_processed" {
  name = "databricks-housing-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "这里放 Databricks 提供的 Principal"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.databricks_external_id
          }
        }
      }
    ]
  })
}