resource "aws_iam_role" "rotation_lambda_role" {
  name = "rds-secret-rotation-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "rotation_policy" {
  name = "rds-secret-rotation-policy"

  policy = file("${path.module}/../iam/lambda-rotation-policy.json")
}

resource "aws_iam_role_policy_attachment" "rotation_attachment" {
  role       = aws_iam_role.rotation_lambda_role.name
  policy_arn = aws_iam_policy.rotation_policy.arn
}

resource "aws_lambda_function" "rotation_handler" {
  function_name = "rds-secret-rotation"

  filename         = "../lambda/rotation-handler.zip"
  source_code_hash = filebase64sha256("../lambda/rotation-handler.zip")

  role    = aws_iam_role.rotation_lambda_role.arn
  handler = "rotation-handler.lambda_handler"
  runtime = "python3.12"

  timeout = 60
}

resource "aws_lambda_permission" "allow_secrets_manager" {
  statement_id  = "AllowSecretsManagerInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rotation_handler.function_name
  principal     = "secretsmanager.amazonaws.com"
}

resource "aws_secretsmanager_secret_rotation" "rotation" {
  secret_id           = aws_secretsmanager_secret.rds_secret.id
  rotation_lambda_arn = aws_lambda_function.rotation_handler.arn

  rotation_rules {
    automatically_after_days = 30
  }

  depends_on = [
    aws_lambda_permission.allow_secrets_manager
  ]
}
