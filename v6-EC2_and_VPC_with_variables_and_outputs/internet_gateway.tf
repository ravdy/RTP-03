
//Creating a Internet Gateway 
resource "aws_internet_gateway" "rtp03-igw" {
    vpc_id = "${aws_vpc.rtp03-vpc.id}"
    tags = {
      Name = "rtp03-igw"
    }
}