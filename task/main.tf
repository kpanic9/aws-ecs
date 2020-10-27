
# ecs container resources
resource "aws_ecs_task_definition" "task_definition" {
  family                = "TaskDef"
  container_definitions = "${file("./task-definition.json")}"

  network_mode = "bridge"

  tags = {
    Name = "TaskDefinition"
  }
}

resource "aws_ecs_service" "service" {
  name                = "nginx-app"
  cluster             = aws_ecs_cluster.app_cluster.id
  task_definition     = aws_ecs_task_definition.task_definition.arn
  scheduling_strategy = "DAEMON"

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_app_target_group.arn
    container_name   = "web"
    container_port   = "80"
  }

}

resource "aws_lb_target_group" "ecs_app_target_group" {
  name     = "EcsAppTargetFroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"

  health_check {
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "EcsAppTargetFroup"
  }
}

# application load balancer for ecs container instances
resource "aws_lb" "ecs_application_lb" {
  name               = "${var.environment}EcsApplicationLB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_sg.id]
  subnets            = [aws_subnet.private_a.id, aws_subnet.private_b.id, aws_subnet.private_c.id]
  idle_timeout       = 720
  tags = {
    Name = "EcsApplicationLayerLB"
  }
}

resource "aws_lb_listener" "ecs_application_lb_listner" {
  load_balancer_arn = aws_lb.ecs_application_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_app_target_group.arn
  }
}
