import boto3
import json
import requests

# Initialize the VPC endpoint URL and API Gateway details
vpc_endpoint_url = 'https://vpce-<endpoint-id>.execute-api.eu-west-1.vpce.amazonaws.com'
rest_api_id = 'ssmpha74bc'
stage_name = 'prod'  # Replace with your actual stage name
resource_path = '/ping'

# Construct the full URL for the private API endpoint
url = f"{vpc_endpoint_url}/{stage_name}{resource_path}"

# Initialize a session using Boto3 to retrieve temporary credentials if needed
session = boto3.session.Session()
credentials = session.get_credentials().get_frozen_credentials()

# Make the request to the VPC endpoint URL
headers = {
    'Authorization': f"AWS4-HMAC-SHA256 Credential={credentials.access_key}/{session.region_name}/execute-api/aws4_request, SignedHeaders=host;x-amz-date;x-amz-security-token, Signature=<signature>",
    'x-amz-date': session.get_credentials().get_frozen_credentials().token,
    'x-amz-security-token': credentials.token
}

# Invoke the API via the VPC endpoint
response = requests.get(url, headers=headers)

# Print the response
print(json.dumps(response.json(), indent=4))
