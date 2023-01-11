






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