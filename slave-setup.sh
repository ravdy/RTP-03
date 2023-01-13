#! /bin/bash
pwd
sudo yum update -y
sudo amazon-linux-extras install java-openjdk11 -y 
sudo yum install maven -y 
sudo yum install docker -y 
service docker start 
chkconfig docker on 
