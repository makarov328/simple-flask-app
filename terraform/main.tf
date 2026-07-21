terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

data "aws_iam_role" "apprunner_ecr_access" {
  name = "apprunner-ecr-access-role"
}

resource "aws_apprunner_service" "staging" {
  service_name = "simple-flask-app-staging"

  source_configuration {
    authentication_configuration {
      access_role_arn = data.aws_iam_role.apprunner_ecr_access.arn
    }

    image_repository {
      image_identifier      = var.ecr_image_identifier
      image_repository_type = "ECR"
      image_configuration {
        port = "8080"
      }
    }
    auto_deployments_enabled = false
  }
}


variable "ecr_image_identifier" {
  description = "The full URI of the Docker image in ECR."
  type        = string
}

output "service_url" {
  value = aws_apprunner_service.staging.service_url
}