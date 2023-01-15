#! /bin/bash
sudo yum update -y
sudo amazon-linux-extras install java-openjdk11 -y 
sudo yum install git maven docker -y 
service docker start 
chkconfig docker on 
