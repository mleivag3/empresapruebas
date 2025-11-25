variable "region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}

variable "project" {
  description = "Project prefix for resource names"
  type = string
  default = "demo-app"
}

variable "cidr_vpc" {
  type = string
  default = "10.10.0.0/16"
}

variable "public_subnets" {
  type = list(string)
  default = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnets" {
  type = list(string)
  default = ["10.10.11.0/24", "10.10.12.0/24"]
}

variable "availability_zones" {
  type = list(string)
  default = ["us-east-1a","us-east-1b"]
}

variable "key_name" {
  description = "Optional EC2 key pair name"
  type = string
  default = ""
}

variable "admin_cidr" {
  description = "CIDR allowed for SSH to instances (set to your IP/32). Leave empty to disable SSH rule."
  type = string
  default = ""
}

variable "db_username" {
  type = string
  default = "demo_user"
}

variable "db_password" {
  description = "RDS password (override in tfvars)"
  type = string
  default = "change_me_db_password"
}

variable "instance_type_ec2" {
  type = string
  default = "t3.micro"
}

variable "rds_instance_class" {
  type = string
  default = "db.t3.micro"
}
