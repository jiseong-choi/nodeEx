resource "aws_alb" "alb" {
  name            = var.aws_alb.name
  subnets         = aws_subnet.public_subnets.*.id
  security_groups = [aws_security_group.public_security_group.id]
}

resource "aws_alb_target_group" "alb_target_group" {
  name        = var.aws_alb_target_group.name
  port        = var.aws_alb_target_group.port
  protocol    = var.aws_alb_target_group.protocol
  vpc_id      = aws_vpc.vpc.id
  target_type = var.aws_alb_target_group.target_type

  health_check {
    path                = var.aws_alb_target_group.health_check.path
    protocol            = var.aws_alb_target_group.health_check.protocol
    healthy_threshold   = var.aws_alb_target_group.health_check.healthy_threshold
    unhealthy_threshold = var.aws_alb_target_group.health_check.unhealthy_threshold
    timeout             = var.aws_alb_target_group.health_check.timeout
    interval            = var.aws_alb_target_group.health_check.interval
    matcher             = var.aws_alb_target_group.health_check.matcher
  }
}

resource "aws_alb_listener" "alb_listener_http" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.aws_alb_listener.http.port

  lifecycle {
    create_before_destroy = true
  }

  default_action {
    type = var.aws_alb_listener.http.default_action.type

    redirect {
      port        = var.aws_alb_listener.http.default_action.redirect.port
      protocol    = var.aws_alb_listener.http.default_action.redirect.protocol
      status_code = var.aws_alb_listener.http.default_action.redirect.status_code
    }
  }
}

resource "aws_alb_listener" "alb_listener_https" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.aws_alb_listener.https.port
  protocol          = var.aws_alb_listener.https.protocol
  ssl_policy        = var.aws_alb_listener.https.ssl_policy
  certificate_arn   = data.aws_acm_certificate.acm_certificate.arn

  lifecycle {
    create_before_destroy = true
  }

  default_action {
    type             = var.aws_alb_listener.https.default_action.type
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
}

resource "aws_route53_record" "route53" {
  name    = var.aws_route53_record.name
  type    = var.aws_route53_record.type
  zone_id = data.aws_route53_zone.route53_zone.zone_id

  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = false
  }
}