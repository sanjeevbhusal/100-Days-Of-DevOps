#!/bin/sh

# update all the repository packages
sudo yum update -y 

# install essential softwares
sudo yum install git docker -y
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-"$(uname -s)"-"$(uname -m)" -o /usr/local/bin/docker-compose

# configure the installed softwares
sudo systemctl start docker
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -a -G docker ec2-user

