# This code is to convert the currency in given table into USD and print the result.
# Importing required libraries
import boto3
import io
import csv
import logging
import os

currency_conversion_to_usd = {'USD':1,'CAD':0.79,'MXN':0.05}

# Creating an s3 client 
REGION_NAME = os.environ.get('AWS REGION','ap-south-1')
LOCALSTACK_ENDPOINT = os.environ.get("LOCALSTACK_ENDPOINT","http://localhost:4566")
s3 = boto3.client(
    's3',
    region_name = REGION_NAME,
    endpoint_url = LOCALSTACK_ENDPOINT,
    aws_access_key_id = os.environ.get("AWS_ACCESS_KEY_ID","test"),
    aws_secret_access_key = os.environ.get("AWS_SECRET_ACCESS_KEY","test")
)

# Configure Logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Function to process each row from the csv file
def process_record(record):
    # Checking if the row is valid
    if not record or len(record) < 9:
        return
    
    try:
        # Unpacking the dat once 
        (id,company_name,country,city,product_line,item,bill_date,currency,bill_amount) = record

        # Converting to float
        bill_amount = float(bill_amount)

        # Conersioning logic
        rate = currency_conversion_to_usd.get(currency) 

        if rate:
            usd_amount = bill_amount*rate
            print(f" ID:{id}, {bill_amount}{currency}->{usd_amount:.2f}USD")
        else:
            logger.info(f"No rate found for currency: {currency}")
            print(f" Id:{id}: No rate found for {currency}")
    except ValueError as e:
        print(f" Skipping malformed row or bad number: {record} / Error: {e}")
    except Exception as e:
        print(f" Unexpected error in row : {e}")

def lambda_handler(event, context):
    try:
        print("1. Extracting bucket and file name")
        bucket = event['Records'][0]['s3']['bucket']['name']
        s3_file = event['Records'][0]['s3']['object']['key']

        print(f"Target bucket: {bucket},file: {s3_file}")

        print("2. Attempting to contact S3")
        response = s3.get_object(Bucket=bucket,Key=s3_file)

        print("3. Reading data")
        data = response['Body'].read().decode('utf-8').splitlines()

        print(f"4. Data loaded! First 50 chars : {data[ :50]}")

        # Using the csv reader to process the csv data
        csv_reader = csv.reader(data)
        try:
            next(csv_reader) # Skip the header row
        except StopIteration:
            print("File is empty")
            return
        for row in csv_reader:
            process_record(row)
    
    except Exception as e:
        print(f"Error processing file: {e}")
        logger.error(f"Error processing file: {e}")

if __name__ == "__main__":
    # Simulating an S3 event
    test_event = {
        "Records": [{
            "s3": {
                "bucket":{"name": "my-billing-bucket"},
                "object":{"key": "billing_data_meat_june_2023.csv"}
            }
        }

        ]
    }
    print("manual test running")
    lambda_handler(test_event,None)
        
