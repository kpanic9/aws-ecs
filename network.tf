provider "aws" {
    region  = "ap-southeast-2"
}

resource "aws_vpc" "vpc" {
    cidr_block       = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support = true
    
    tags = {
        Name = "ECS-VPC"
    }
}

# avpc public subnet and routing configuration
resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.vpc.id}"

    tags = {
        Name = "IGW"
    }
}

resource "aws_subnet" "public_a" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.public_subnet_a_ip_range}"
    availability_zone = "ap-southeast-2a"

    tags = {
        Name = "PublicSubnetA"
    }
}

resource "aws_subnet" "public_b" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.public_subnet_b_ip_range}"
    availability_zone = "ap-southeast-2b"
    
    tags = {
        Name = "PublicSubnetB"
    }
}

resource "aws_subnet" "public_c" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.public_subnet_c_ip_range}"
    availability_zone = "ap-southeast-2c"
    
    tags = {
        Name = "PublicSubnetC"
    }
}

resource "aws_route_table" "public_subnet_rt" {
    vpc_id = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }

    tags = {
        Name = "PublicRouteTable"
    }
}

resource "aws_route_table_association" "public_subnet_a_association" {
    subnet_id = "${aws_subnet.public_a.id}"
    route_table_id = "${aws_route_table.public_subnet_rt.id}"
}

resource "aws_route_table_association" "public_subnet_b_association" {
    subnet_id = "${aws_subnet.public_b.id}"
    route_table_id = "${aws_route_table.public_subnet_rt.id}"
}

resource "aws_route_table_association" "public_subnet_c_association" {
    subnet_id = "${aws_subnet.public_c.id}"
    route_table_id = "${aws_route_table.public_subnet_rt.id}"
}

