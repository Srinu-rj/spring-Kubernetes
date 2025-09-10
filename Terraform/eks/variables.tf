variable "aws_region" {
  default = "ap-south-1"
}

variable "cluster_name" {
  default = "springboot-eks"
}

variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS"
  type        = list(string)
}
