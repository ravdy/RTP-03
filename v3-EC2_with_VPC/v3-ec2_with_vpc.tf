provider "aws" {
  region = "us-east-1"
  profile = "default"
}

resource "aws_instance" "ec2" {
    ami = "ami-0b0dcb5067f052a63"
    instance_type = "t2.micro"
    key_name = "prd01"
   // security_groups = ["rtp03-sg"]
   vpc_security_group_ids = ["${aws_security_group.rtp03-sg.id}"]
   subnet_id = "${aws_subnet.rtp03-public_subent_01.id}"
}

resource "aws_security_group" "rtp03-sg" {
    name = "rtp03-sg"
    vpc_id = "${aws_vpc.rtp03-vpc.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ssh-sg"

    }

}

//creating a VPC
resource "aws_vpc" "rtp03-vpc" {
    cidr_block = "10.1.0.0/16"
    tags = {
      Name = "rpt03-vpc"
    }
  
}

// Creatomg a Subnet 
resource "aws_subnet" "rtp03-public_subent_01" {
    vpc_id = "${aws_vpc.rtp03-vpc.id}"
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "rtp03-public_subent_01"
    }
  
}

//Creating a Internet Gateway 
resource "aws_internet_gateway" "rtp03-igw" {
    vpc_id = "${aws_vpc.rtp03-vpc.id}"
    tags = {
      Name = "rtp03-igw"
    }
}

// Create a route table 
resource "aws_route_table" "rtp03-public-rt" {
    vpc_id = "${aws_vpc.rtp03-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.rtp03-igw.id}"
    }
    tags = {
      Name = "rtp03-public-rt"
    }
}

// Associate subnet with routetable 

resource "aws_route_table_association" "rtp03-rta-public-subent-1" {
    subnet_id = "${aws_subnet.rtp03-public_subent_01.id}"
    route_table_id = "${aws_route_table.rtp03-public-rt.id}"
  
}