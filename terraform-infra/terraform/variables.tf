variable "environment"{
    type        = string
    default     = "dev"
    description = "Deployment environment (dev,staging,prod)"
}

variable "project_name"{
     type = string
     default = "cloud-app"
     description = "Project prefix for resource naming"
}