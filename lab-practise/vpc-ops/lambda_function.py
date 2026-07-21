# This code is to check if any existing elastic ips are present that are not in use and release them if not in use
import boto3
import os

# Creating a user defined function to locate elastic ips
def lambda_handler(event,context):
    # Creating an ec2 resource
    endpoint_url = os.environ.get('LOCALSTACK_ENDPOINT',"http://localhost:4566")
    region_name = os.environ.get('REGION_NAME',"ap-south-1")
    ec2 = boto3.resource(
        'ec2',
        region_name = region_name,
        endpoint_url = endpoint_url,
        aws_access_key_id = os.environ.get("AWS_ACCESS_KEY_ID","test"),
        aws_secret_access_key = os.environ.get("AWS_SECRET_ACCESS_KEY","test")
    )
    released_ips = []

    all_ips = list(ec2.vpc_addresses.all())
    print(f"Total Elastic IPs found in LocalStack: {len(all_ips)}")
    # Creating a loop to check all the elastic ips
    for elastic_ip in all_ips:
        if elastic_ip.association_id is None:
            ip_address = elastic_ip.public_ip
            alloc_id = elastic_ip.allocation_id
            print(f"Unassociated Elastic IP found: {elastic_ip.public_ip} (Allocation ID: {elastic_ip.allocation_id})")
            elastic_ip.release()
            released_ips.append(ip_address)
            print(f"Released Elastic IP: {ip_address}(Allocation ID: {alloc_id})")
        else:
            print(f"Elastic IP {ip_address} (Allocation ID: {alloc_id}) is currently associated with an instance.")

    return{
        'statuscode':200,
        'body':{
            'message': 'Processed Elastic IPs completely',
            'released_ips': released_ips,
            'total_released': len(released_ips) 
        }
    }

if __name__ == "__main__":
    print(lambda_handler(None,None))