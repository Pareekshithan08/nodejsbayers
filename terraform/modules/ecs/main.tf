provider "aws" {
  region = "us-west-1"
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with resources in this module"
  type        = string
}

resource "aws_ecs_cluster" "main" {
  name = "my-ecs-fargate-cluster"
  tags = {
    Name = "my-ecs-cluster"
  }
}

resource "aws_ecs_task_definition" "patient_service" {
  family                   = "patient-service-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "patient-service"
      image     = "${aws_ecr_repository.patient.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# resource "aws_ecs_cluster" "main" {
#   name = "fargate-cluster"
# }

# resource "aws_ecs_task_definition" "web" {
#   family                   = "fargate-task"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "256"
#   memory                   = "512"
#   network_mode             = "myvpc"
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

#   container_definitions = jsonencode([
#     {
#       name  = "web-app"
#       image = var.ecs_image_url
#       essential = true
#       portMappings = [{
#         containerPort = 80
#         hostPort      = 80
#         protocol      = "tcp"
#       }]
#     }
#   ])
# }

# resource "aws_ecs_service" "web" {
#   name            = "web-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.web.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets         = [aws_subnet.public.id]
#     assign_public_ip = true
#     security_groups  = [aws_security_group.ecs_service_sg.id]
#   }
# }
