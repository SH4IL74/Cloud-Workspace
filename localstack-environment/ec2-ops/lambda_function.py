import json
import logging
import boto3
import os
from datetime import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event,context):
    # Checking if we are running in Localstack
    localstack_host = os.environ.get('LOCALSTACK_HOSTNAME')
    localstack_endpoint = os.environ.get('LOCALSTACK_ENDPOINT')
    volume_id = event.get("volume_id","vol-1e6638e0781d12022")  # Default volume ID if not provided in the event

    if localstack_host:
        # Use 'localhost.localstack.cloud' or just the host provided by env
        localstack_host = os.environ.get('LOCALSTACK_HOSTNAME','localhost')
        endpoint_url = f"http://{localstack_host}:4566"
        ec2 = boto3.client('ec2',endpoint_url=endpoint_url,region_name='ap-south-1')
    elif localstack_endpoint:
        ec2 = boto3.client('ec2',endpoint_url=localstack_endpoint,region_name='ap-south-1')
    else:
        # Connect to real AWS console
        ec2 = boto3.client('ec2',region_name='ap-south-1')
    
    current_date = datetime.now().strftime('%Y-%m-%d')

    try:
        # Creating volume id first using CLI to avoid snapshot failure
        response = ec2.create_snapshot(
            VolumeId = volume_id,
            Description = 'Testing EC2 Snapshot',
            TagSpecifications = [
                {
                    'ResourceType':'snapshot',
                    'Tags':[
                        {
                            'Key':'Name',
                            'Value':f'Testing EC2 Snapshot{current_date}'
                        }
                    ]
                }
            ]
        )
        logger.info(f'Successfully created snapshot: {json.dumps(response,default=str)}')
        
        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Snapshot created successfully",
                "snapshot_id": str(response.get("SnapshotId"))
            })
        }
    
    except Exception as e:
        logger.error(f'Error creating snapshot: {str(e)}')
        return{
            "statusCode":500,
            "body":json.dumps({"error":str(e)})
        }
