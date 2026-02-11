variable "aws_region" { type = string, default = "us-east-1" }
variable "cluster_version" { type = string, default = "1.30" }
variable "instance_types" { type = list(string), default = ["t3.large"] }
variable "desired_nodes" { type = number, default = 2 }
variable "min_nodes" { type = number, default = 2 }
variable "max_nodes" { type = number, default = 6 }
variable "db_instance_class" { type = string, default = "db.t4g.small" }
variable "db_username" { type = string, default = "postgres" }
variable "db_password" { type = string, sensitive = true }
variable "vpc_cidr" { type = string, default = "10.20.0.0/16" }
variable "public_subnets" {
  type = map(object({ cidr = string, az = string }))
  default = {
    az1 = { cidr = "10.20.1.0/24", az = "us-east-1a" }
    az2 = { cidr = "10.20.2.0/24", az = "us-east-1b" }
  }
}
variable "private_subnets" {
  type = map(object({ cidr = string, az = string }))
  default = {
    az1 = { cidr = "10.20.11.0/24", az = "us-east-1a" }
    az2 = { cidr = "10.20.12.0/24", az = "us-east-1b" }
  }
}
