variable "vpc_cidr" {
  description = "ECS VPC CIDR"
}

variable "public_subnet_a_ip_range" {
  description = "Public subnet a ip address range"
}

variable "public_subnet_b_ip_range" {
  description = "Public subnet b ip address range"
}

variable "public_subnet_c_ip_range" {
  description = "Public subnet c ip address range"
}

variable "private_subnet_a_ip_range" {
  description = "Private subnet a ip address range"
}

variable "private_subnet_b_ip_range" {
  description = "Private subnet b ip address range"
}

variable "private_subnet_c_ip_range" {
  description = "private subnet c ip address range"
}

variable "secure_subnet_a_ip_range" {
  description = "Secure subnet a ipaddress range"
}

variable "secure_subnet_b_ip_range" {
  description = "Secure subnet b ip address range"
}

variable "secure_subnet_c_ip_range" {
  description = "Secure subnet c ip address range"
}

variable "image_id" {
  description = "ECS optimized amazon linux image id"
}

variable "instance_type" {
  description = "ECS instance type"
}

variable "keyname" {
  description = "SSH Key pair name"
}

variable "maximum_nodes" {
  description = "Maximum ECS nodes for ECS ASG"
}

variable "minimum_nodes" {
  description = "Minimum ECS nodes for ECS ASG"
}

variable "desired_nodes" {
  description = "Desired ECS nodes for ECS ASG"
}
