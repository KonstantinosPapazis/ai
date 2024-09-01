import requests

# Define the API Gateway endpoint URL
api_endpoint = "https://ssmpha74bc.execute-api.eu-west-1.amazonaws.com/test/ping"

try:
    # Send a GET request to the API endpoint
    response = requests.get(api_endpoint)

    # Check if the response was successful
    if response.status_code == 200:
        print("Success! Connected to API Gateway.")
        print("Response data:", response.json())  # Assuming the response is in JSON format
    else:
        print(f"Failed to connect. Status code: {response.status_code}")
        print("Response data:", response.text)  # Print the raw response text if not JSON

except requests.exceptions.RequestException as e:
    print(f"An error occurred: {e}")
