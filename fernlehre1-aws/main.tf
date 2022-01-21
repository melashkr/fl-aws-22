# Data Source for getting Amazon Linux AMI
data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

# Resource for dealstore-backend-provider
resource "aws_instance" "dealstore-backend-p" {
  ami                    = data.aws_ami.amazon-2.id
  instance_type          = "t3.micro"
  user_data              = templatefile("${path.module}/templates/init_backend.tpl", {})
  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-http.id]

  tags = {
    Name = "dealstore-backend-provider"
  }
}

# Resource for dealstore-backend-deal
resource "aws_instance" "dealstore-backend-d" {
  ami                    = data.aws_ami.amazon-2.id
  instance_type          = "t3.micro"
  user_data              = templatefile("${path.module}/templates/init_backend.tpl", {})
  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-http.id]

  tags = {
    Name = "dealstore-backend-deal"
  }
}

# Resource for dealstore-frontend
resource "aws_instance" "dealstore-frontend" {
  ami           = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"
  user_data = templatefile("${path.module}/templates/init_frontend.tpl", {
    backendUrlProvider = "http://${aws_instance.dealstore-backend-p.public_ip}:8080",
    backendUrlDeal     = "http://${aws_instance.dealstore-backend-d.public_ip}:8080"
  })
  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-http.id]

  tags = {
    Name = "dealstore-frontend"
  }

}

resource "aws_security_group" "ingress-all-ssh" {
  name = "allow-all-ssh-backend"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-all-http" {
  name = "allow-all-http-backend"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
