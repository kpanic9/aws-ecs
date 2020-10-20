variable "vpc_cidr" {
  description = "ECS VPC CIDR"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_a_ip_range" {
  description = "Public subnet A ip address range"
  type = string
}

variable "public_subnet_b_ip_range" {
  description = "Public subnet B ip address range"
  type = string
}

variable "public_subnet_c_ip_range" {
  description = "Public subnet C ip address range"
  type = string
}

variable "private_subnet_a_ip_range" {
  description = "Private subnet A ip address range"
  type = string
}

variable "private_subnet_b_ip_range" {
  description = "Private subnet B ip address range"
  type = string
}

variable "private_subnet_c_ip_range" {
  description = "private subnet C ip address range"
  type = string
}

variable "secure_subnet_a_ip_range" {
  description = "Secure subnet A ipaddress range"
  type = string
}

variable "secure_subnet_b_ip_range" {
  description = "Secure subnet B ip address range"
  type = string
}

variable "secure_subnet_c_ip_range" {
  description = "Secure subnet C ip address range"
  type = string
}

variable "image_id" {
  description = "ECS optimized amazon linux image id"
  type = string
}

variable "instance_type" {
  description = "ECS instance type"
  type = string
}

variable "keyname" {
  description = "SSH Key pair name"
  type = string
}

variable "maximum_nodes" {
  description = "Maximum ECS nodes for ECS ASG"
  type = string
}

variable "minimum_nodes" {
  description = "Minimum ECS nodes for ECS ASG"
  type = string
}

variable "desired_nodes" {
  description = "Desired ECS nodes for ECS ASG"
  type = string
}
