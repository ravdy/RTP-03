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
        from_port = 4000
        to_port = 4000
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