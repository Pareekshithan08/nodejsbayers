resource "aws_ecs_task_definition" "patient_service" {
  family                   = "patient-service-task"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "256"  # 0.25 vCPU
  memory                  = "512"  # 512 MiB
  execution_role_arn      = "arn:aws:iam::539935451710:role/ecsTaskExecutionRoleHclBayerPatientpareek"
  task_role_arn           = "arn:aws:iam::539935451710:role/ecsTaskExecutionRoleHclBayerPatientpareek"

  container_definitions = jsonencode([
    {
      name      = "patient-service"
      image     = "539935451710.dkr.ecr.us-west-1.amazonaws.com/hclbayerpatientpareek:latest"
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