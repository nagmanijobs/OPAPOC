"""CDK Stack for Lambda function with API Gateway and S3 integration."""

import aws_cdk as cdk
from aws_cdk import (
    aws_lambda as lambda_,
    aws_apigateway as apigw,
    aws_s3 as s3,
)
from constructs import Construct
import os


class LambdaStack(cdk.Stack):
    """Stack that creates Lambda, API Gateway, and S3 bucket for login storage."""

    def __init__(self, scope: Construct, id: str, **kwargs):
        super().__init__(scope, id, **kwargs)

        # Create S3 bucket for storing login information
        login_bucket = s3.Bucket(
            self,
            "LoginDataBucket",
            versioned=True,
            block_public_access=s3.BlockPublicAccess.BLOCK_ALL,
            encryption=s3.BucketEncryption.S3_MANAGED,
            removal_policy=cdk.RemovalPolicy.DESTROY,  # Only for demo, use RETAIN in production
        )

        # Create Lambda function
        lambda_function = lambda_.Function(
            self,
            "HelloWorldLambda",
            code=lambda_.Code.from_asset(
                os.path.join(os.path.dirname(__file__), "../lambda_handler")
            ),
            handler="index.handler",
            runtime=lambda_.Runtime.PYTHON_3_11,
            environment={
                "LOGIN_BUCKET": login_bucket.bucket_name,
            },
            timeout=cdk.Duration.seconds(30),
            memory_size=256,
        )

        # Grant Lambda permissions to read/write to S3 bucket
        login_bucket.grant_read_write(lambda_function)

        # Create API Gateway REST API
        api = apigw.RestApi(
            self,
            "HelloWorldAPI",
            rest_api_name="Hello World API",
            description="API Gateway for Hello World Lambda",
            default_cors_preflight_options=apigw.CorsOptions(
                allow_origins=apigw.Cors.ALL_ORIGINS,
                allow_methods=apigw.Cors.ALL_METHODS,
                allow_headers=["Content-Type", "Authorization"],
            ),
        )

        # Add Lambda integration to API Gateway
        lambda_integration = apigw.LambdaIntegration(lambda_function)

        # Create /hello endpoint
        hello_resource = api.root.add_resource("hello")
        hello_resource.add_method("GET", lambda_integration)
        hello_resource.add_method("POST", lambda_integration)

        # Create /login endpoint
        login_resource = api.root.add_resource("login")
        login_resource.add_method("POST", lambda_integration)

        # Output the API Gateway URL
        cdk.CfnOutput(
            self,
            "APIGatewayURL",
            value=api.url,
            description="API Gateway endpoint URL",
            export_name="HelloWorldAPIURL",
        )

        # Output the S3 bucket name
        cdk.CfnOutput(
            self,
            "LoginBucketName",
            value=login_bucket.bucket_name,
            description="S3 bucket for storing login information",
            export_name="LoginBucketName",
        )

        # Output the Lambda function name
        cdk.CfnOutput(
            self,
            "LambdaFunctionName",
            value=lambda_function.function_name,
            description="Lambda function name",
            export_name="HelloWorldLambdaName",
        )
