output "VPC_name" {
    description = "VPC id name"
    value = "${aws_vpc.rtp03-vpc.id}" 
  
}

output "jenkins-public-ip" {
    description = "this is jenkins master ip"
    value = try(aws_instance.demo-ec2["master"].public_ip,"")
  
}

output "slave-public-ip" {
    description = "this is jenkins slave ip"
    value = try(aws_instance.demo-ec2["slave"].public_ip,"")
}

output "ansible-public-ip" {
    description = "this is Ansible public ip"
    value = try(aws_instance.demo-ec2["ansible"].public_ip,"")
  
}

output "public-subnet1" {
   description = "this is Public subnet 1"
   value = "${aws_subnet.rtp03-public_subnet_01.id}"
}
output "public-subnet2" {
   description = "this is Public subnet 2"
   value = "${aws_subnet.rtp03-public_subnet_02.id}"
}
