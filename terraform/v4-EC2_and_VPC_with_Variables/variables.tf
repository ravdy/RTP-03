variable "ami" {
    default = "ami-0b0dcb5067f052a63"  
}

variable "instance_type" {
    default = "t2.micro"
}

variable "key-name" {
    default = "prd01"
}

variable "vpc_cidr" {
    default = "10.1.0.0/16"
}

variable "subnet_cidr" {
    default = "10.1.1.0/24"
}
