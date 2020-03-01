vpc_cidr                  = "10.0.0.0/16"
public_subnet_a_ip_range  = "10.0.1.0/24"
public_subnet_b_ip_range  = "10.0.2.0/24"
public_subnet_c_ip_range  = "10.0.3.0/24"
private_subnet_a_ip_range = "10.0.4.0/24"
private_subnet_b_ip_range = "10.0.5.0/24"
private_subnet_c_ip_range = "10.0.6.0/24"
secure_subnet_a_ip_range  = "10.0.7.0/24"
secure_subnet_b_ip_range  = "10.0.8.0/24"
secure_subnet_c_ip_range  = "10.0.9.0/24"
image_id                  = "ami-039bb4c3a7946ce19" # 2019-07 ECS Optimized
instance_type             = "t3.large"
keyname                   = ""
minimum_nodes             = 1
maximum_nodes             = 5
desired_nodes             = 1
