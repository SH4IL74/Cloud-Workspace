variable "environment"{
    type        = string
    default     = "dev"
    description = "Deployment environment (dev,staging,prod)"
}

variable "project_name"{
     type        = string
     default     = "cloud-app"
     description = "Project prefix for resource naming"
}

# New networking variables
variable "vpc_cidr"{
    type        = string
    default     = "10.0.0.0/16"
    description = "IP CIDR block for the VPC"
}

variable "public_subnet_cidr"{
    type        = string
    default     = "10.0.1.0/24"
    description = "IP CIDR block for the public subnet"
}