# Local variables evaluated dynamically per workspace
locals{
    env = terraform.workspace

    # VPC CIDR lookup map based on active workspace 
    vpc_cidrs = {
        dev     = "10.0.0.0/16"
        prod    = "10.2.0.0/16"
        default = "10.0.0.0/16"
    }

    # Subnet CIDR lookup map based on active workspace 
    subnet_cidrs = {
        dev     = "10.0.1.0/24"
        prod    = "10.2.1.0/24"
        default = "10.0.1.0/24"
    }
}

# Single module block that adjusts dynamically per workspace
module "app_environment"{
    source = "../modules/app-stack"
    environment = local.env
    project_name = "cloud-app"
    vpc_cidr = lookup(local.vpc_cidrs,local.env,local.vpc_cidrs["default"])
    public_subnet_cidr = lookup(local.subnet_cidrs,local.env,local.subnet_cidrs["default"])
}