# AWS ECS
 
Provisioning VPC and three layers of subnets (public, private, secure) with related network infrastructure
ECS Cluster with auto scaling cluster instance nodes
Deploy sample application


## How to use
 
```bash
git clone repo
cd aws-ecs/
set values for configs in terraform.tfvars file. This will give some amount of configuration options
terraform apply
```
 
## TODO
 
1. Use remote backend for storing terraform state (S3) 
2. Implement RDS 
3. Use an actual application instead of NGINX 
4. Implement a deployement strategy to remove the downtime of application deployments 
 
