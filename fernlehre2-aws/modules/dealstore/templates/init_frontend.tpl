#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo docker run --name ds_v3 --rm -it  -p 8080:8080  -e VUE_APP_ROOT_API_P=${backendUrlProvider} -e VUE_APP_ROOT_API_D=${backendUrlDeal} -d adlolab/dealstore_frontend:v3