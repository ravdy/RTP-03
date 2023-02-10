variable "ami" {
    default = "ami-0cca134ec43cf708f"
  
}

variable "instance_type" {
    default = "t2.micro"
  
}

variable "key" {

    default = "rtp-03"
  
}

variable "vpc" {

    default = "10.2.0.0/16"
  
}

variable "subnet" {

    default = "10.2.2.0/24"
  
}

variable "subnet2" {

    default = "10.2.3.0/24"
  
}
