To build your AWS Lambda function locally using a virtual environment (venv) and then create a deployment package, follow these steps:
Step 1: Set Up a Virtual Environment

    Create a Project Directory:

    bash

mkdir my_lambda_function
cd my_lambda_function

Create a Virtual Environment:

bash

python3 -m venv venv

Activate the Virtual Environment:

    On Linux/Mac:

    bash

source venv/bin/activate

On Windows:

bash

        .\venv\Scripts\activate

Step 2: Install the Required Packages

    Install the requests Package:

    bash

pip install requests

Verify the Installation:

bash

    pip freeze

    This command should list requests and its dependencies.

Step 3: Prepare the Deployment Package

    Create the Lambda Function File:
        Create a Python file named lambda_function.py in your project directory.
        Example content for lambda_function.py:

        python

    import requests

    def lambda_handler(event, context):
        response = requests.get("https://api.example.com/data")
        return {
            'statusCode': 200,
            'body': response.json()
        }

Create the Deployment Package:

    Navigate to the site-packages directory inside the virtual environment:

    bash

cd venv/lib/python3.8/site-packages/  # Adjust the Python version number as needed

Zip the contents of the site-packages directory:

bash

zip -r9 ../../../../lambda_function.zip .

Include your lambda_function.py file in the zip package:

bash

        cd ../../../../  # Navigate back to the project root directory
        zip -g lambda_function.zip lambda_function.py

Step 4: Deploy the Lambda Function

    Upload the Deployment Package:
        Go to the AWS Management Console, navigate to your Lambda function.
        Under "Function code," select "Upload from" and choose ".zip file."
        Upload the lambda_function.zip file.

Step 5: Test the Function

    Test Your Lambda Function:
        Use the AWS Lambda console to test your function with different events to ensure it behaves as expected.

Additional Tips

    Deactivate the Virtual Environment: After you've created the deployment package, deactivate the virtual environment:

    bash

    deactivate

    Handling Large Packages: If your package becomes too large for Lambda (exceeding the 50 MB deployment package size), consider using Lambda Layers to include the dependencies separately.

Following these steps should allow you to successfully build, package, and deploy your Lambda function with the requests module using a virtual environment.