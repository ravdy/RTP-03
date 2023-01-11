provider "aws" {
  region = "us-east-1"
  profile = "default"
}

resource "aws_instance" "ec2" {
    ami = "ami-0b0dcb5067f052a63"
    instance_type = "t2.micro"
    key_name = "prd01"
}
