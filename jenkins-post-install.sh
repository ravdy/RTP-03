#!/bin/sh
pwd
sudo yum update -y 
sudo yum install docker -y

# Install docker compose
  wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
  sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
  sudo chmod -v +x /usr/local/bin/docker-compose
  sudo systemctl enable docker.service
  sudo systemctl start docker.service
  sudo systemctl status docker.service

# Configure Docker Compose
  sudo usermod -aG docker $USER
  sudo chgrp docker /usr/local/bin/docker-compose
  sudo chmod 750 /usr/local/bin/docker-compose
  newgrp docker
  chmod 777 /var/run/docker.sock
