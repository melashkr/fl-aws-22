#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo docker run -p 8080:8080 -e PORT=8080 -e HATS_HOST=${hats_host} -e HATS_PORT=8080 -e ARMS_HOST=${arms_host} -e ARMS_PORT=8080 -e LEGS_HOST=${legs_host} -e LEGS_PORT=8080 -d ${container_image}:${podtato_version}
sudo amazon-linux-extras install epel -y
sudo yum-config-manager --enable epel
sudo yum install certbot -y
export PUBLIC_URL=$(curl http://169.254.169.254/latest/meta-data/public-ipv4).nip.io
sudo certbot certonly --standalone --preferred-challenges http -d $${PUBLIC_URL} --dry-run -m 'test@gmail.com' --agree-tos
sudo certbot certonly --standalone --preferred-challenges http -d $${PUBLIC_URL} --staging -m 'test@gmail.com' --agree-tos
echo '-----created certbot----'
mkdir -p /tmp/oauth2-proxy
sudo mkdir -p /opt/oauth2-proxy
cd /tmp/oauth2-proxy
curl -sfL https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v7.1.3/oauth2-proxy-v7.1.3.linux-amd64.tar.gz | tar -xzvf -
echo 'run curl sfl'
sudo mv oauth2-proxy-v7.1.3.linux-amd64/oauth2-proxy /opt/oauth2-proxy/
export COOKIE_SECRET=$(python -c 'import os,base64; print(base64.urlsafe_b64encode(os.urandom(16)).decode())')
export GITHUB_USER=${GITHUB_USER}
export GITHUB_CLIENT_ID=${GITHUB_CLIENT_ID}
export GITHUB_CLIENT_SECRET=${GITHUB_CLIENT_SECRET}
export PUBLIC_URL=$(curl http://169.254.169.254/latest/meta-data/public-ipv4).nip.io
sleep 1m
sudo /opt/oauth2-proxy/oauth2-proxy --github-user=$GITHUB_USER  --cookie-secret=$COOKIE_SECRET --client-id=$GITHUB_CLIENT_ID --client-secret=$GITHUB_CLIENT_SECRET --email-domain='*' --upstream=http://127.0.0.1:8080 --provider github --cookie-secure false --redirect-url=https://$$PUBLIC_URL/oauth2/callback --https-address=':443' --force-https --tls-cert-file=/etc/letsencrypt/live/$$PUBLIC_URL/fullchain.pem --tls-key-file=/etc/letsencrypt/live/$$PUBLIC_URL/privkey.pem



