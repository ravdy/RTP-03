variable "ami" {
    default = "ami-0b0dcb5067f052a63"  
}

variable "associate_ip" {
    default = true
  
}
variable "instance_type" {
    default = "t2.micro"
}

variable "key-name" {
    default = "prd01"
}

variable "vpc_cidr" {
    default = "10.3.0.0/16"
}

variable "subnet_cidr" {
    default = "10.3.1.0/24"
}