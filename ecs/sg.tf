# security group for bastion host
resource "aws_security_group" "bastion" {
  name   = "bastion"
  vpc_id = aws_vpc.vpc.id

  // allow incoming ssh traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // allow icmp traffic from bastion sg
  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
    self      = true
  }

  // allow all egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion"
  }
}

# external alb security group, http and https traffic is allowed from anywhere
resource "aws_security_group" "external_alb" {
  name   = "external-alb"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "external-alb"
  }
}

# ecs node security group
resource "aws_security_group" "app" {
  name   = "application"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    self            = true
    security_groups = [aws_security_group.external_alb_sg.id]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "application"
  }
}

# database security group, ingress is allowed from ecs nodes
resource "aws_security_group" "database" {
  name   = "database"
  vpc_id = aws_vpc.vpc.id

  // allow incoming trafffic to postgress database server
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app_sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database"
  }
}
