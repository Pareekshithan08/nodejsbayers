resource "aws_ecs_service" "patient_service" {
  name            = "patient-service"
  cluster         = aws_ecs_cluster.main.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.patient_service.arn
  desired_count   = 1

  network_configuration {
    subnets         = [aws_subnet.private1.id, aws_subnet.private2.id] # Replace with your private subnet IDs
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs_tasks.id]
  }

  depends_on = [
    aws_iam_role.ecs_task_execution_role,
    aws_cloudwatch_log_group.patient_service
  ]
}