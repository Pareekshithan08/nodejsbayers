provider "aws" {
  region = "us-west-1"
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with resources in this module"
  type        = string
}

resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = "hclbayerpatient"  # Replace with your desired repository name
  image_tag_mutability = "IMMUTABLE" # Or "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "BayerPatient"
    Environment = "Development"
  }
}