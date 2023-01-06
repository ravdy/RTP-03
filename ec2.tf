//Creating VPC 
resource "aws_vpc" "prd01-vpc" {
    cidr_block = "10.0.0.0/16"
    
    tags = {
        Name = "prd01-vpc"
    }
}

// Creating Subnet 
resource "aws_subnet" "prd01-subent-public-01" {
    vpc_id = "${aws_vpc.prd01-vpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "us-east-1a"
    tags = {
        Name = "prd01-subent-public-01"
    }
}

// Create internete Gateway 
resource "aws_internet_gateway" "prd01-igw" {
    vpc_id = "${aws_vpc.prd01-vpc.id}"
    tags = {
        Name = "prd01-igw"
    }
}
// Create Route Table 
resource "aws_route_table" "prd01-public-crt" {
    vpc_id =  "${aws_vpc.prd01-vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.prd01-igw.id}" 
    }
    
    tags = {
        Name = "prd01-public-crt"
    }
}

// Associate subnet with routetable 
resource "aws_route_table_association" "prd01-crta-public-subnet-1"{
    subnet_id = "${aws_subnet.prd01-subent-public-01.id}"
    route_table_id = "${aws_route_table.prd01-public-crt.id}"
}

// Create Security group 
resource "aws_security_group" "ssh-sg" {
    vpc_id = "${aws_vpc.prd01-vpc.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
    //If you do not add this rule, you can not reach the NGIX  
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "ssh-sg"
    }
}

// Create EC2 instance 

resource "aws_instance" "jenkins" {
    ami = "ami-0b0dcb5067f052a63"
    instance_type = "t2.micro"
    # VPC
    subnet_id = "${aws_subnet.prd01-subent-public-01.id}"
    # Security Group
    vpc_security_group_ids = ["${aws_security_group.ssh-sg.id}"]
    # the Public SSH key
    key_name = "prd01"
}