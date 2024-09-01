#pip install requests-aws4auth

import boto3
import json
import requests
from requests_aws4auth import AWS4Auth

# Initialize the VPC endpoint URL and API Gateway details
vpc_endpoint_url = 'https://vpce-0f79134bd6bdef9cd-e0z5bmpr.execute-api.eu-west-1.vpce.amazonaws.com'
rest_api_id = 'ssmpha74bc'
stage_name = 'test'
resource_path = '/ping'

# Construct the full URL for the private API endpoint
url = f"{vpc_endpoint_url}/{stage_name}{resource_path}"

# Get the session credentials
session = boto3.session.Session()
credentials = session.get_credentials().get_frozen_credentials()

# Setup AWS4Auth for signing the request
aws_auth = AWS4Auth(credentials.access_key, credentials.secret_key, session.region_name, 'execute-api', session_token=credentials.token)

# Invoke the API via the VPC endpoint
response = requests.get(url, auth=aws_auth)

# Print the response
print(json.dumps(response.json(), indent=4))
