provider "aws" {
  region = "us-west-1"
}

resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = "nodepat"  # Replace with your desired repository name
  image_tag_mutability = "IMMUTABLE" # Or "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "BayerPatient"
    Environment = "Development"
  }
}