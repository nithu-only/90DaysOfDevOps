module "vpc" {
  source = "./modules/vpc"

  cidr               = var.vpc_cidr
  public_subnet_cidr = var.subnet_cidr
  environment        = local.environment
  project_name       = var.project_name
}

module "sg" {
  source = "./modules/security-group"

  vpc_id        = module.vpc.vpc_id
  ingress_ports = var.ingress_ports
  environment   = local.environment
  project_name  = var.project_name
}

module "ec2" {
  source = "./modules/ec2-instance"

  ami_id            = "ami-0c55b159cbfafe1f0" # update region-wise
  instance_type     = var.instance_type
  subnet_id         = module.vpc.subnet_id
  security_group_ids = [module.sg.sg_id]
  environment       = local.environment
  project_name      = var.project_name
}