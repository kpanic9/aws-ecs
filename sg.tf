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

# external alb security group, http and https traffic is allowed from anywhere
resource "aws_security_group" "external_alb_sg" {
    name = "ExternalAlbSG"
    vpc_id = "${aws_vpc.vpc.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
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
        Name = "ExternalAlbSG"
    }
}

# ecs node security group
resource "aws_security_group" "app_sg" {
    name = "${var.environment}ApplicationSG"
    vpc_id = "${data.aws_vpc.finda_vpc.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        self = true
        security_groups = ["${aws_security_group.external_alb_sg.id}"]
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = ["${aws_security_group.bastion_host_sg.id}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ApplicationSG"
    }
}
