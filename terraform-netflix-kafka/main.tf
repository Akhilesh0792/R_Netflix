# 1. VPC
module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

# 2. Subnets
module "subnets" {
  source          = "./modules/subnets"
  project_name    = var.project_name
  vpc_id          = module.vpc.vpc_id
  igw_id          = module.vpc.igw_id
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# 3. NACL
module "nacl" {
  source            = "./modules/nacl"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = values(module.subnets.public_subnet_ids)
}

# 4. Security Groups
module "security_groups" {
  source       = "./modules/security_groups"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

# 5. Frontend EC2 (In Public Subnet)
module "netflix_frontend" {
  source              = "./modules/ec2"
  instance_name       = "${var.project_name}-frontend"
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  key_name            = var.key_name
  subnet_id           = module.subnets.public_subnet_ids["pub-1"]
  security_group_ids  = [module.security_groups.frontend_sg_id]
  associate_public_ip = true
  disk_size           = 25
  role                = "netflix_app"
}

# 6. ALB
module "alb" {
  source             = "./modules/alb"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.security_groups.alb_sg_id]
  subnet_ids         = values(module.subnets.public_subnet_ids)
  target_instance_id = module.netflix_frontend.instance_id
}

# 7. Kafka Cluster (for_each loop)
module "kafka_nodes" {
  source   = "./modules/ec2"
  for_each = var.kafka_nodes

  instance_name       = each.key
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  key_name            = var.key_name
  subnet_id           = module.subnets.private_subnet_ids[each.value.subnet_key]
  security_group_ids  = [module.security_groups.kafka_sg_id]
  associate_public_ip = false
  disk_size           = each.value.disk_size
  role                = "kafka"
}

# 8. VPC Peering Connection
module "vpc_peering" {
  source                        = "./modules/vpc_peering"
  project_name                  = var.project_name
  target_vpc_id                 = module.vpc.vpc_id
  peer_vpc_id                   = var.control_vpc_id
  target_private_route_table_id = module.subnets.private_route_table_id
  peer_route_table_id           = var.control_route_table_id
  target_vpc_cidr               = var.vpc_cidr
  peer_vpc_cidr                 = var.control_vpc_cidr
}