provider "aws" {
  region = "us-west-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ecr" {
  source = "./modules/ecr"
    vpc_id = module.roles.vpc_id
}

module "ecs" {
  source = "./modules/ecs"
    vpc_id = module.roles.vpc_id
}

module "iam" {
  source = "./modules/roles"
    vpc_id = module.roles.vpc_id
}

# module "ecssecurity_groups" {
#   source = "./modules/security_groups"
#   # Input variables for your security groups module
#   vpc_id = module.vpc.vpc_id # Referencing output from vpc module
#   # ... other security group variables
# }

# module "alb" {
#   source = "./modules/alb"
#   # Input variables for your ALB module
#   vpc_id = module.vpc.vpc_id
#   public_subnet_ids = module.vpc.public_subnet_ids
#   security_group_id = module.security_groups.alb_security_group_id
#   # ... other ALB variables
# }

# module "ecs" {
#   source = "./modules/ecs"
#   # Input variables for your ECS module
#   cluster_name = "my-node-app-cluster"
#   task_definition_image = "your-ecr-repo-url/your-node-app:latest"
#   vpc_id = module.vpc.vpc_id
#   private_subnet_ids = module.vpc.private_subnet_ids
#   # ... other ECS variables
# }
