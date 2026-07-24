variable "environment" {
    type = string
    default = "dev"
    description = "Deployment environment {dev,stage,prod}"
}

variable "project_name" {
    type = string
    default = "cloud-app"
    description = "Project prefix for resource naming"
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
    description = "IP CIDR block for vpc"
}

variable "public_subnet_cidr" {
    type = string
    default = "10.0.1.0/24"
    description = "IP CIDR block for public subnet"
}