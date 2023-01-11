
//creating a VPC
resource "aws_vpc" "rtp03-vpc" {
    cidr_block = var.vpc_cidr
    tags = {
      Name = "rpt03-vpc"
    }
  
}