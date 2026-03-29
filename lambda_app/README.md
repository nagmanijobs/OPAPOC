# Cloud-Native Hello World Lambda App

A sample AWS cloud-native application built with Lambda, API Gateway, and S3 using AWS CDK. This application demonstrates how to create a serverless API with login functionality that stores credentials in S3.

## Architecture

```
API Gateway
    ↓
  Lambda Function
    ↓
  S3 Bucket (Login Storage)
```

### Components

- **AWS Lambda**: Serverless compute function handling HTTP requests
- **API Gateway**: REST API endpoint for accessing Lambda function
- **S3 Bucket**: Secure storage for login information with versioning and encryption
- **AWS CDK**: Infrastructure as Code for deployment automation

## Project Structure

```
lambda_app/
├── cdk/
│   ├── app.py              # CDK application entry point
│   └── lambda_stack.py     # Stack definition with resources
├── lambda_handler/
│   └── index.py            # Lambda handler function
├── requirements.txt        # Python dependencies
└── README.md              # This file
```

## Prerequisites

- Python 3.11 or higher
- AWS CDK CLI installed: `npm install -g aws-cdk`
- AWS credentials configured (`aws configure`)
- AWS account with IAM permissions

## Setup Instructions

### 1. Install Python Dependencies

```bash
cd lambda_app
pip install -r requirements.txt
```

### 2. Bootstrap CDK (First time only)

```bash
cd cdk
cdk bootstrap aws://YOUR_ACCOUNT_ID/YOUR_REGION
```

Replace `YOUR_ACCOUNT_ID` and `YOUR_REGION` with your actual AWS account ID and region.

### 3. Deploy the Stack

```bash
cd cdk
cdk deploy
```

The deployment will output:
- **APIGatewayURL**: The endpoint to access your API
- **LoginBucketName**: The S3 bucket name for login storage
- **LambdaFunctionName**: The Lambda function name

## API Endpoints

### 1. GET /hello
Returns a simple hello world response.

**Request:**
```bash
curl -X GET https://<API_GATEWAY_URL>/hello
```

**Response:**
```json
{
    "message": "Hello, World!",
    "timestamp": "2024-01-15T10:30:45.123456",
    "service": "Cloud-Native Lambda App"
}
```

### 2. POST /hello
Returns a personalized hello message.

**Request:**
```bash
curl -X POST https://<API_GATEWAY_URL>/hello \
  -H "Content-Type: application/json" \
  -d '{"name": "John"}'
```

**Response:**
```json
{
    "message": "Hello, John!",
    "timestamp": "2024-01-15T10:30:45.123456",
    "service": "Cloud-Native Lambda App"
}
```

### 3. POST /login
Stores login credentials to S3 bucket.

**Request:**
```bash
curl -X POST https://<API_GATEWAY_URL>/login \
  -H "Content-Type: application/json" \
  -d '{"username": "user@example.com", "password": "password123"}'
```

**Response:**
```json
{
    "message": "Login successful for user user@example.com",
    "timestamp": "2024-01-15T10:30:45.123456",
    "stored_in_s3": "logins/2024-01-15T10:30:45.123456-user@example.com.json",
    "notice": "WARNING: Storing plain text passwords is NOT recommended in production..."
}
```

## File Structure

### app.py
Entry point for the CDK application. Initializes and synthesizes the stack.

### lambda_stack.py
Defines the CDK stack with:
- **S3 Bucket**: For storing login information with encryption and versioning
- **Lambda Function**: Handles API requests and S3 operations
- **API Gateway**: Provides REST API interface with CORS support
- **IAM Permissions**: Grants Lambda read/write access to S3

### index.py (Lambda Handler)
Contains the business logic:
- `handler()`: Main entry point for Lambda invocations
- `handle_hello_get()`: Processes GET /hello requests
- `handle_hello_post()`: Processes POST /hello requests with custom names
- `handle_login()`: Processes login requests and stores to S3

## Security Notes

⚠️ **WARNING**: This is a demo application for learning purposes. Do NOT use in production as:

1. **Plain Text Passwords**: Credentials are stored in plain text. Use:
   - AWS Secrets Manager for credential storage
   - AWS Cognito for user authentication
   - Encryption at rest and in transit

2. **No Authentication**: API Gateway endpoints are public. Add:
   - API Keys
   - AWS IAM authentication
   - Lambda authorizers
   - OAuth/JWT tokens

3. **S3 Encryption**: While AES256 encryption is enabled, consider:
   - Customer-managed KMS keys
   - Object-level encryption validation

## Cleanup

To remove all AWS resources created by this stack:

```bash
cd cdk
cdk destroy
```

## Environment Variables

The Lambda function uses the following environment variable:
- `LOGIN_BUCKET`: Name of the S3 bucket for login storage (automatically set by CDK)

## Cost Estimation

This stack uses AWS Free Tier eligible services:
- **Lambda**: 1 million free requests per month
- **API Gateway**: 1 million API calls free for 12 months (new accounts)
- **S3**: 5 GB free storage for 12 months (new accounts)

## Troubleshooting

### CDK Deploy Fails
- Verify AWS credentials: `aws sts get-caller-identity`
- Ensure CDK is bootstrapped: `cdk bootstrap`
- Check IAM permissions for CloudFormation, Lambda, API Gateway, and S3

### Lambda Execution Errors
- Check CloudWatch Logs: `aws logs tail /aws/lambda/HelloWorldLambda-* --follow`
- Verify S3 bucket permissions
- Check Lambda function timeout settings

### API Gateway Returns 502
- Check Lambda logs for errors
- Verify Lambda has S3 access permissions
- Ensure Lambda execution role is properly configured

## Further Improvements

1. Add request validation and input sanitization
2. Implement proper authentication and authorization
3. Add CloudWatch monitoring and alarms
4. Implement database instead of S3 for login records
5. Add comprehensive error handling and logging
6. Implement rate limiting and throttling
7. Add API documentation (OpenAPI/Swagger)
8. Implement CI/CD pipeline for automated deployment

## References

- [AWS CDK Documentation](https://docs.aws.amazon.com/cdk/latest/guide/)
- [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/latest/dg/)
- [API Gateway Documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/)
- [S3 Documentation](https://docs.aws.amazon.com/s3/latest/userguide/)

## License

This is a sample application for educational purposes.
