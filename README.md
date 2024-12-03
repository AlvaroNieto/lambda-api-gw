# Lambda function + Api Gateway into DynamoDB

Deploy a DynamoDB to store a visit counter. Create a Lambda function with boto3 lib that updates and queries the current visit. Then use the API Gateway to access the Lambda function.

## Steps

The steps to take are:

    1. Deploy DynamoDB
    2. Create the Lambda function
    3. Create and configure the API Gateway.
    4. Retry with Terraform.

Result: 

![Image](pic.jpg "Result Image")
