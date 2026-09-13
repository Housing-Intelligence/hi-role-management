variable databricks_external_id {
  type        = string
}

resource "aws_iam_role_policy" "databricks_s3" {
  name = "databricks-housing-s3-policy"
  role = aws_iam_role.databricks_data.id

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
          "arn:aws:s3:::housing-intelligence-data/raw_data/*",
          "arn:aws:s3:::housing-intelligence-data/processed_data/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "databricks_data" {
  name = "databricks-housing-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL",
            "arn:aws:iam::844096318338:role/databricks-housing-s3-role"
          ]
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