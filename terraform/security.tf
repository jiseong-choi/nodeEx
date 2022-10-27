resource "aws_security_group" "private_security_group" {
  name        = var.aws_security_group.private.name
  description = var.aws_security_group.private.description
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = var.aws_security_group.private.container_ingress.from_port
    to_port     = var.aws_security_group.private.container_ingress.to_port
    protocol    = var.aws_security_group.private.container_ingress.protocol
    cidr_blocks = var.aws_security_group.private.container_ingress.cidr_blocks
  }

  ingress {
    from_port   = var.aws_security_group.private.database_ingress.from_port
    to_port     = var.aws_security_group.private.database_ingress.to_port
    protocol    = var.aws_security_group.private.database_ingress.protocol
    cidr_blocks = var.aws_security_group.private.database_ingress.cidr_blocks
  }

  egress {
    from_port   = var.aws_security_group.private.egress.from_port
    to_port     = var.aws_security_group.private.egress.to_port
    protocol    = var.aws_security_group.private.egress.protocol
    cidr_blocks = var.aws_security_group.private.egress.cidr_blocks
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "public_security_group" {
  name        = var.aws_security_group.public.name
  description = var.aws_security_group.public.description
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = var.aws_security_group.public.container_ingress.from_port
    to_port     = var.aws_security_group.public.container_ingress.to_port
    protocol    = var.aws_security_group.public.container_ingress.protocol
    cidr_blocks = var.aws_security_group.public.container_ingress.cidr_blocks
  }

  ingress {
    from_port   = var.aws_security_group.public.database_ingress.from_port
    to_port     = var.aws_security_group.public.database_ingress.to_port
    protocol    = var.aws_security_group.public.database_ingress.protocol
    cidr_blocks = var.aws_security_group.public.database_ingress.cidr_blocks
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.aws_security_group.public.egress.from_port
    to_port     = var.aws_security_group.public.egress.to_port
    protocol    = var.aws_security_group.public.egress.protocol
    cidr_blocks = var.aws_security_group.public.egress.cidr_blocks
  }

  lifecycle {
    create_before_destroy = true
  }
}