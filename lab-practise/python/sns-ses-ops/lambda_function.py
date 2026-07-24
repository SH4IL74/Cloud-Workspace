import json, boto3, os, csv

def lambda_handler(event, context):
    localstack_host = os.environ.get('LOCALSTACK_HOSTNAME', 'localhost')
    endpoint = f"http://{localstack_host}:4566"
    REGION = "ap-south-1"
    
    s3 = boto3.client('s3', endpoint_url=endpoint, region_name=REGION)
    sns = boto3.client('sns', endpoint_url=endpoint, region_name=REGION)
    ses = boto3.client('ses', endpoint_url=endpoint, region_name=REGION)

    try:
        bucket = event['Records'][0]['s3']['bucket']['name']
        key = event['Records'][0]['s3']['object']['key']
        
        # 1. S3 Process
        s3.get_object(Bucket=bucket, Key=key)
        
        # 2. Extract string TopicArn from response dictionary
        topic_res = sns.create_topic(Name='TaxesAPIConnectionError')
        actual_topic_arn = topic_res['TopicArn']  # <--- MUST extract the ['TopicArn'] key!
        
        # 3. SNS Alert
        sns.publish(
            TopicArn=actual_topic_arn,
            Message=f"Manual Override Success: Processed {key}",
            Subject="Pipeline Update"
        )

        # 4. Move File
        s3.copy_object(Bucket="my-processed-bucket", CopySource={'Bucket': bucket, 'Key': key}, Key=key)
        s3.delete_object(Bucket=bucket, Key=key)

        # 5. SES Email
        ses.send_email(
            Source='shail@example.com',
            Destination={'ToAddresses': ['shail@example.com']},
            Message={'Subject': {'Data': 'Success'}, 'Body': {'Text': {'Data': 'File moved.'}}}
        )
        return {"statusCode": 200, "body": "Success"}
    except Exception as e:
        return {"statusCode": 500, "body": str(e)}