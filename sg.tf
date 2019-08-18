# security group for bastion host
resource "aws_security_group" "bastion_host_sg" {
    name = "BastionSG"
    vpc_id = "${aws_vpc.vpc.id}"


    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        self = true
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "BastionHostSG"
    }
}
