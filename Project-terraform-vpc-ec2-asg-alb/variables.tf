variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "stylish-website"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {
    Environment = "production"
    Project     = "stylish-website"
    Terraform   = "true"
  }
}

variable "website_node_ami" {
  description = "AMI ID for Jenkins nodes"
  type        = string
  default     = "ami-09a9858973b288bdd"  
}

variable "website_node_instance_type" {
  description = "Instance type for Jenkins nodes"
  type        = string
  default     = "t3.small"
}

variable "website_node_count" {
  description = "Desired number of Jenkins nodes"
  type        = number
  default     = 2
}

variable "website_node_min_count" {
  description = "Minimum number of Jenkins nodes"
  type        = number
  default     = 1
}

variable "website_node_max_count" {
  description = "Maximum number of Jenkins nodes"
  type        = number
  default     = 4
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "sandeep_putty_2025"
}

variable "iam_instance_profile" {
  description = "Name of the IAM instance profile"
  type        = string
  default     = "MySessionManagerrole"
}

