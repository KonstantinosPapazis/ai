import os
import boto3
import requests
from botocore.auth import SigV4Auth
from botocore.awsrequest import AWSRequest
from botocore.credentials import Credentials
from botocore.session import get_session
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

# Function to sign and send the request
def invoke_api_gateway():
    # API Gateway details
    api_gateway_id = "ssmpha74bc"  # Replace with your API Gateway ID
    region = "eu-west-1"
    stage = "test"
    resource = "/ping"
    api_endpoint = f"https://{api_gateway_id}.execute-api.{region}.amazonaws.com/{stage}{resource}"

    # Initialize a session using boto3
    session = boto3.Session()
    credentials = session.get_credentials().get_frozen_credentials()

    # Create an AWSRequest
    request = AWSRequest(method="GET", url=api_endpoint)

    # Sign the request with SigV4
    SigV4Auth(credentials, "execute-api", region).add_auth(request)

    # Prepare the request for the 'requests' library
    prepared_request = requests.Request(
        method=request.method,
        url=request.url,
        headers=dict(request.headers)
    ).prepare()

    # Send the signed request
    try:
        response = requests.Session().send(prepared_request, timeout=10)
        if response.status_code == 200:
            logger.info("Success! Connected to API Gateway.")
            logger.info(f"Response data: {response.json()}")
            return response.json()
        else:
            logger.error(f"Failed to connect. Status code: {response.status_code}")
            logger.error(f"Response data: {response.text}")
            return None
    except requests.exceptions.RequestException as e:
        logger.error(f"Request failed: {e}")
        return None

# Invoke the API
result = invoke_api_gateway()
