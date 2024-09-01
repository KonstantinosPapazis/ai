import os
import boto3
import requests
from botocore.auth import SigV4Auth
from botocore.awsrequest import AWSRequest
from botocore.exceptions import NoCredentialsError

def lambda_handler(event, context):
    api_gateway_id = os.environ.get("API_GATEWAY_ID")
    if not api_gateway_id:
        return {
            "statusCode": 500,
            "body": "API_GATEWAY_ID environment variable is not set."
        }

    api_endpoint = f"https://{api_gateway_id}.execute-api.eu-west-1.amazonaws.com/test/ping"

    try:
        session = boto3.Session()
        request = AWSRequest(method="GET", url=api_endpoint)
        SigV4Auth(session.get_credentials().get_frozen_credentials(), "execute-api", "eu-west-1").add_auth(request)

        prepared_request = requests.Request(
            method=request.method,
            url=request.url,
            headers=dict(request.headers)
        ).prepare()

        response = requests.Session().send(prepared_request, timeout=10)

        if response.status_code == 200:
            return {
                "statusCode": 200,
                "body": f"Success! Connected to API Gateway. Response data: {response.json()}"
            }
        else:
            return {
                "statusCode": response.status_code,
                "body": f"Failed to connect. Response data: {response.text}"
            }

    except NoCredentialsError as e:
        return {
            "statusCode": 403,
            "body": f"No credentials found: {str(e)}"
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"An error occurred: {str(e)}"
        }
