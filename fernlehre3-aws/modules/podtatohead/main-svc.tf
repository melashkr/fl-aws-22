resource "aws_launch_configuration" "podtatohead-main" {
  image_id        = data.aws_ami.amazon-2.image_id
  instance_type   = "t3.micro"
  user_data       = base64encode(templatefile("${path.module}/templates/init_main.tpl", { 
    container_image = "ghcr.io/fhb-codelabs/podtato-small-main", hats_host = aws_instance.podtatohead-hats.private_ip, arms_host = aws_instance.podtatohead-arms.private_ip, legs_host = aws_instance.podtatohead-legs.private_ip, podtato_version = var.podtato_version, 
    dns_name=aws_elb.main_elb.dns_name,
    GITHUB_USER=var.GITHUB_USER,
    GITHUB_CLIENT_ID=var.GITHUB_CLIENT_ID,
    GITHUB_CLIENT_SECRET=var.GITHUB_CLIENT_SECRET

    }))
  security_groups = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-http.id]
  name_prefix     = "${var.podtato_name}-podtatohead-main-"

  key_name = "vockey"
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "asg-podtatohead-main" {
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  desired_capacity   = var.desired_instances
  max_size           = var.max_instances
  min_size           = var.min_instances
  name               = "${var.podtato_name}-main-asg"

  launch_configuration = aws_launch_configuration.podtatohead-main.name

  health_check_type = "ELB"
  load_balancers = [
    aws_elb.main_elb.id
  ]


  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      instance_warmup        = "60"
    }
    triggers = ["tag"]
  }

  tag {
    key                 = "Name"
    value               = "${var.podtato_name}-podtatohead-main"
    propagate_at_launch = true
  }
}

resource "aws_elb" "main_elb" {
  name               = "${var.podtato_name}-main-elb"
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  security_groups = [
    aws_security_group.elb_http.id
  ]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:8080/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "8080"
    instance_protocol = "http"
  }
}
