provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "medusa_cluster" {
  name = "medusa-cluster"
}

resource "aws_ecs_task_definition" "medusa_task" {
  family                = "medusa-task"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name  = "medusa"
    image = "${aws_ecr_repository.medusa_repo.repository_url}:latest"
    cpu   = 256
    memory = 512
    essential = true
    portMappings = [{
      containerPort = 9000
      hostPort      = 9000
    }]
  }])
}

resource "aws_ecs_service" "medusa_service" {
  cluster        = aws_ecs_cluster.medusa_cluster.id
  task_definition = aws_ecs_task_definition.medusa_task.arn
  desired_count  = 1
  launch_type    = "FARGATE"
  network_configuration {
    subnets         = aws_subnet.private_subnets[*].id
    security_groups = [aws_security_group.ecs_security_group.id]
  }
}
