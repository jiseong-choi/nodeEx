resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.aws_ecs_cluster.name
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.aws_ecs_task_definition.family
  network_mode             = var.aws_ecs_task_definition.network_mode
  requires_compatibilities = var.aws_ecs_task_definition.requires_compatibilities
  cpu                      = var.aws_ecs_task_definition.cpu
  memory                   = var.aws_ecs_task_definition.memory
  execution_role_arn       = aws_iam_role.admin_role.arn
  task_role_arn            = aws_iam_role.admin_role.arn
  container_definitions = jsonencode([
    {
      name      = var.aws_ecs_task_definition.container_definitions.name
      image     = aws_ecr_repository.ecr_repository.repository_url
      essential = var.aws_ecs_task_definition.container_definitions.essential
      cpu       = var.aws_ecs_task_definition.container_definitions.cpu
      memory    = var.aws_ecs_task_definition.container_definitions.memory
      portMappings = [
        {
          containerPort = var.aws_ecs_task_definition.container_definitions.portMappings.containerPort
          hostPort      = var.aws_ecs_task_definition.container_definitions.portMappings.hostPort
          protocol      = var.aws_ecs_task_definition.container_definitions.portMappings.protocol
        }
      ]
      logConfiguration = {
        logDriver = var.aws_ecs_task_definition.container_definitions.logConfiguration.logDriver
        options = {
          "awslogs-group"         = var.aws_ecs_task_definition.container_definitions.logConfiguration.options.awslogs-group
          "awslogs-region"        = var.aws_ecs_task_definition.container_definitions.logConfiguration.options.awslogs-region
          "awslogs-stream-prefix" = var.aws_ecs_task_definition.container_definitions.logConfiguration.options.awslogs-stream-prefix
        }
      }
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.aws_ecs_service.name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = var.instance_count
  launch_type     = var.aws_ecs_service.launch_type

  network_configuration {
    security_groups  = [aws_security_group.private_security_group.id]
    subnets          = aws_subnet.private_subnets.*.id
    assign_public_ip = var.aws_ecs_service.network_configuration.assign_public_ip
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_target_group.id
    container_name   = var.aws_ecs_service.load_balancer.container_name
    container_port   = var.aws_ecs_service.load_balancer.container_port
  }

  depends_on = [aws_alb_listener.alb_listener_http, aws_alb_listener.alb_listener_https]
}