#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo docker run -d -p 8080:80 -e PORT=8080 --name myapp waelamer/webapi_v1:1