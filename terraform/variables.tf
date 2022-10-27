variable "name" {
  type = string
}

variable "ecr_repository" {
  type = string
}

variable "iam_role" {
  type = string
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "port" {
  type = number
}

variable "root_domain" {
  type = string
}

variable "record_domain" {
  type = string
}

variable "min_capacity" {
  type    = number
  default = 1
}

variable "max_capacity" {
  type    = number
  default = 2
}

variable "instance_cpu" {
  type    = string
  default = "1024"
}

variable "instance_memory" {
  type    = string
  default = "2048"
}

variable "container_cpu" {
  type    = number
  default = 512
}

variable "container_memory" {
  type    = number
  default = 1024
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "aws_provider" {
  type = object({
    region  = string
    profile = string
  })
}

variable "aws_vpc" {
  type = object({
    cidr_block           = string
    enable_dns_hostnames = bool
    enable_dns_support   = bool
    instance_tenancy     = string
    tags = object({
      Name = string
    })
  })
}

variable "aws_subnet" {
  type = object({
    count             = number
    availability_zone = list(string)
    private_subnet = object({
      Name = string
    })
    public_subnet = object({
      Name = string
    })
  })
}

variable "aws_internet_gateway" {
  type = object({
    tags = object({
      Name = string
    })
  })
}

variable "aws_route" {
  type = object({
    destination_cidr_block = string
  })
}

variable "aws_eip" {
  type = object({
    count = number
    vpc   = bool
    tags = object({
      Name = string
    })
  })
}

variable "aws_nat_gateway" {
  type = object({
    count = number
  })
}

variable "aws_route_table" {
  type = object({
    count = number
    route = object({
      cidr_block = string
    })
  })
}

variable "aws_route_table_association" {
  type = object({
    count = number
  })
}

variable "aws_ecr_repository" {
  type = object({
    name = string
  })
}

variable "aws_ecs_cluster" {
  type = object({
    name = string
  })
}

variable "aws_ecs_task_definition" {
  type = object({
    family                   = string
    requires_compatibilities = list(string)
    cpu                      = string
    memory                   = string
    network_mode             = string
    container_definitions = object({
      name      = string
      memory    = number
      cpu       = number
      essential = bool
      portMappings = object({
        containerPort = number
        hostPort      = number
        protocol      = string
      })
      logConfiguration = object({
        logDriver = string
        options = object({
          awslogs-group         = string
          awslogs-region        = string
          awslogs-stream-prefix = string
        })
      })
    })
  })
}

variable "aws_ecs_service" {
  type = object({
    name          = string
    desired_count = number
    launch_type   = string
    network_configuration = object({
      assign_public_ip = bool
    })
    load_balancer = object({
      container_name = string
      container_port = number
    })
  })
}

variable "aws_acm_certificate" {
  type = object({
    domain = string
  })
}

variable "aws_route53_zone" {
  type = object({
    name = string
  })
}

variable "aws_route53_record" {
  type = object({
    name = string
    type = string
    alias = object({
      evaluate_target_health = bool
    })
  })
}

variable "aws_alb_target_group" {
  type = object({
    name        = string
    port        = number
    protocol    = string
    target_type = string
    health_check = object({
      path                = string
      protocol            = string
      interval            = string
      timeout             = string
      healthy_threshold   = string
      unhealthy_threshold = string
      matcher             = string
    })
  })
}

variable "aws_alb_listener" {
  type = object({
    http = object({
      port     = string
      protocol = string
      default_action = object({
        type = string
        redirect = object({
          port        = string
          protocol    = string
          status_code = string
        })
      })
    })
    https = object({
      port       = string
      protocol   = string
      ssl_policy = string
      lifecycle = object({
        create_before_destroy = bool
      })
      default_action = object({
        type = string
      })
    })
  })
}

variable "aws_cloudwatch_log_group" {
  type = object({
    name              = string
    retention_in_days = number
    tags = object({
      Name = string
    })
  })
}

variable "aws_cloudwatch_log_stream" {
  type = object({
    name = string
  })
}

variable "aws_appautoscaling_target" {
  type = object({
    scalable_dimension = string
    service_namespace  = string
    max_capacity       = number
    min_capacity       = number
  })
}

variable "aws_appautoscaling_policy" {
  type = object({
    up = object({
      name               = string
      service_namespace  = string
      scalable_dimension = string
      step_scaling_policy_configuration = object({
        adjustment_type         = string
        cooldown                = number
        metric_aggregation_type = string
        step_adjustment = object({
          metric_interval_lower_bound = number
          scaling_adjustment          = number
        })
      })
    })
    down = object({
      name               = string
      service_namespace  = string
      scalable_dimension = string
      step_scaling_policy_configuration = object({
        adjustment_type         = string
        cooldown                = number
        metric_aggregation_type = string
        step_adjustment = object({
          metric_interval_upper_bound = number
          scaling_adjustment          = number
        })
      })
    })
  })
}

variable "aws_cloudwatch_metric_alarm" {
  type = object({
    high = object({
      alert_name          = string
      comparison_operator = string
      evaluation_periods  = string
      metric_name         = string
      namespace           = string
      period              = string
      statistic           = string
      threshold           = string
    })
    low = object({
      alert_name          = string
      comparison_operator = string
      evaluation_periods  = string
      metric_name         = string
      namespace           = string
      period              = string
      statistic           = string
      threshold           = string
    })
  })
}

variable "aws_security_group" {
  type = object({
    public = object({
      name        = string
      description = string
      container_ingress = object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      })
      database_ingress = object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      })
      egress = object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      })
      lifecycle = object({
        create_before_destroy = bool
      })
    })
    private = object({
      name        = string
      description = string
      container_ingress = object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      })
      database_ingress = object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      })
      egress = object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      })
      lifecycle = object({
        create_before_destroy = bool
      })
    })
  })
}

variable "aws_alb" {
  type = object({
    name = string
  })
}