resource "aws_ecs_task_definition" "patient_service" {
  family                   = "patient-service-task"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "256"  # 0.25 vCPU
  memory                  = "512"  # 512 MiB
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn           = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "patient-service"
      image     = "${aws_ecr_repository.patient.repository_url}:latest"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/patient-service"
          awslogs-region        = "us-west-1" # change if needed
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}