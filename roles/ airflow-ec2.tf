resource "aws_iam_role" "airflow_ec2" {
  name = "airflow-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_policy" "airflow_runtime" {
  name = "airflow-runtime-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      # Secrets Manager
      {
        Sid    = "ReadAirflowSecret"
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = var.airflow_secret_arn
      },

      # ECR authentication
      {
        Sid    = "ECRAuthorization"
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },

      # ECR image pull
      {
        Sid    = "ECRPull"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]

        Resource = var.airflow_ecr_repository_arn
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "airflow_runtime" {
  role       = aws_iam_role.airflow_ec2.name
  policy_arn = aws_iam_policy.airflow_runtime.arn
}


resource "aws_iam_instance_profile" "airflow_ec2" {
  name = "airflow-ec2-instance-profile"

  role = aws_iam_role.airflow_ec2.name
}