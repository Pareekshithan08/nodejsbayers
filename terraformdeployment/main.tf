resource "aws_ecs_cluster" "main" {
  name = "fargate-cluster-pat"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "node-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = arn:aws:iam::539935451710:role/ecsTaskExecutionRoleHclBayerPat

  container_definitions = jsonencode([
    {
      name      = "node-app"
      image     = 539935451710.dkr.ecr.us-west-1.amazonaws.com/bayerhclpat:latest
      essential = true
      portMappings = [{
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/node-app"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "node-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public.id] # Ensure NAT or IGW exists
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_service_sg.id]
  }
    load_balancer {
        target_group_arn = arn:aws:elasticloadbalancing:us-west-1:539935451710:targetgroup/cb-target-group/7612f6c61bd64ae8
        container_name   = "node-app"
        container_port   = 80
    }

  depends_on = [aws_ecs_task_definition.app]
}