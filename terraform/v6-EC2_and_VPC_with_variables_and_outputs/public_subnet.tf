

// Creatomg a Subnet 
resource "aws_subnet" "rtp03-public_subent_01" {
    vpc_id = "${aws_vpc.rtp03-vpc.id}"
    cidr_block = var.subnet_cidr
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "rtp03-public_subent_01"
    }
  
}