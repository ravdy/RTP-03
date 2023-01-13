output "vpc-name" {
    description = "this is vpc id"
    value = "${aws_vpc.rtp03-vpc.id}"
  
}

output "jenkins-public-ip" {
    description = "this is jenkins master ip"
    value = try(aws_instance.ec2["master"].public_ip,"")
  
}

output "slave-public-ip" {
    description = "this is jenkins slave ip"
    value = try(aws_instance.ec2["slave"].public_ip,"")
  
}

output "security_group" {
    value = "${aws_security_group.rtp03-sg.id}"
  
}

output "public_subent" {
    value = "${aws_subnet.rtp03-public_subent_01.id}"
}


