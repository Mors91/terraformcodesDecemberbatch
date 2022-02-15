resource "aws_lb" "main" {
  name               = join("-", [local.network.Environment, "alb"])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh.id, aws_security_group.allow_alb.id]
  subnets            = [aws_subnet.main-public.id, aws_subnet.main-public-2.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.elitebucketdev.bucket
    prefix  = "alb"
    enabled = true
  }

  tags = merge(local.common_tags, { Name = "mainalb", Company = "EliteSolutionsIT" })
}

//Target Group
resource "aws_lb_target_group" "main-target" {
  name     = join("-", [local.network.Environment, "maintargetgroup"])
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    timeout             = "5"
    interval            = "30"
    matcher             = "200"
    path                = "/"
  }
}

///attachment
resource "aws_lb_target_group_attachment" "main-attach" {
  target_group_arn = aws_lb_target_group.main-target.arn
  target_id        = aws_instance.ubuntuserver.id
  port             = 80
}

///redirect listener
resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

///https listener
resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:375866976303:certificate/68fd3867-2d7e-4153-9c89-9822fb5e59b8"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main-target.arn
  }
}
