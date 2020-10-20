# AWS ECS

Terraform module for provisioning an ECS cluster. This module provisions,
- a VPC and three layers of subnets (public, private, secure) with related network infrastructure
- an ECS cluster with auto scaling for cluster instances   
- a bastion host  

## How to use
 
```bash
git clone repo
cd aws-ecs/
```
Set values for configs in terraform.tfvars file. This will give some amount of configuration options
```bash
terraform apply
```
 
## TODO
 
1. Use remote backend for storing terraform state (S3) 
2. Implement RDS 
3. Use an actual application instead of NGINX 
4. Implement a deployement strategy to remove the downtime of application deployments 
 