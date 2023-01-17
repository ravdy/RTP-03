
resource "aws_instance" "demo-ec2" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key
  vpc_security_group_ids = ["${aws_security_group.rtp03-sg.id}"]
   subnet_id = "${aws_subnet.rtp03-public_subnet_01.id}"
   for_each = toset(["master", "slave", "ansible"])
   tags = {
     Name = "${each.key}"
   }
}
