# Set up S3 Buckets and RDS Subnet Groups

import sys
sys.path.append('..')
from config.localstack_client import get_boto_client

s3 = get_boto_client('s3')
rds = get_boto_client('rds')

def create_storage_and_database(private_subnet_ids,db_sg_id):
    print(" Provisioning S3 and RDS")

    # S3 Storage
    bucket_name = "private-cloud-app-media"
    s3.create_bucket(Bucket=bucket_name)

    # RDS DB Subnet Group (Required for isolated custom VPC DB deployments)
    rds.create_db_subnet_group(
        DBSubnetGroupName='private-cloud-db-subnet-group',
        DBSubnetGroupDescription='DB subnets across multi-AZ',
        SubnetIds=private_subnet_ids
    )

    # Database Instance 
    rds.create_db_instance(
        DBInstanceIdentifier="private-cloud-db",
        AllocatedStorage=20,
        DBInstanceClass="db.t3.micro",
        Engine="postgres",
        MasterUsername="postgres",
        MasterUserPassword="SecurePassword123",
        DBSubnetGroupName="private-cloud-db-subnet-group",
        VpcSecurityGroupIds=[db_sg_id]
    )
    print(" Storage and DB Provisioned")

