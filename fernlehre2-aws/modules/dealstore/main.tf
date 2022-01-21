# Data Source for getting Amazon Linux AMI
data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

# Resource for backend-deal -> backend-deal
resource "aws_instance" "backend-deal" {
  ami           = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"
  user_data = templatefile("${path.module}/templates/init_backend.tpl", {
  })
  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-http.id]

  tags = {
    Name = "${var.frontend_name}-backend-deal"
  }

}

# Resource for backend-provider -> backend-provider
resource "aws_instance" "backend-provider" {
  ami           = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"
  user_data = templatefile("${path.module}/templates/init_backend.tpl", {
  })
  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-http.id]

  tags = {
    Name = "${var.frontend_name}-backend-provider"
  }
}

resource "aws_security_group" "ingress-all-ssh" {

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  name = "${var.frontend_name}-allow-all-ssh"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-all-http" {

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
  }
  name = "${var.frontend_name}-allow-all-http"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "elb_http" {
  name        = "${var.frontend_name}-elb_http"
  description = "Allow HTTP traffic to instances through Elastic Load Balancer"

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "Allow HTTP through ELB Security Group"
  }
}
