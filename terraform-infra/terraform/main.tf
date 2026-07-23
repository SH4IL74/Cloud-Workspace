# Development Environment
module "dev_environment"{
    source             = "../modules/app-stack"
    environment        = "dev"
    project_name       = "cloud-app"
    vpc_cidr           = "10.0.0.0/16"
    public_subnet_cidr = "10.0.1.0/24"
}

# Staging Environment (Isolated Network & Storage)
module "staging_environment"{
    source           = "../modules/app-stack"
    environment      = "staging"
    project_name     = "cloud-app"
    vpc_cidr         = "10.1.0.0/16"
    public_subnet_cidr = "10.1.1.0/24"
}