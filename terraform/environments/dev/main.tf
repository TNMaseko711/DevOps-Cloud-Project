provider "aws" {
  region = var.aws_region
}

locals {
  name = "ecommerce-dev"
  tags = {
    Environment = "dev"
    Project     = "DevOpsCloudProject"
    Owner       = "platform-team"
    CostCenter  = "engineering"
  }
}

module "vpc" {
  source          = "../../modules/vpc"
  name            = local.name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = local.tags
}

resource "aws_security_group" "eks" {
  name        = "${local.name}-eks-sg"
  description = "EKS cluster security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_security_group" "rds" {
  name   = "${local.name}-rds-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

module "iam" {
  source = "../../modules/iam"
  name   = local.name
  tags   = local.tags
}

module "eks" {
  source           = "../../modules/eks"
  cluster_name     = local.name
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn
  cluster_version  = var.cluster_version
  subnet_ids       = module.vpc.private_subnet_ids
  instance_types   = var.instance_types
  capacity_type    = "SPOT"
  desired_nodes    = 2
  min_nodes        = 1
  max_nodes        = 3
  tags             = local.tags
}

module "rds" {
  source            = "../../modules/rds"
  name              = local.name
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_id = aws_security_group.rds.id
  instance_class    = "db.t4g.micro"
  allocated_storage = 20
  db_name           = "ecommerce"
  username          = var.db_username
  password          = var.db_password
  tags              = local.tags
}

module "alb" {
  source            = "../../modules/alb"
  name              = local.name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = aws_security_group.eks.id
  tags              = local.tags
}

module "observability" {
  source             = "../../modules/observability"
  name               = local.name
  log_retention_days = 14
  tags               = local.tags
}
