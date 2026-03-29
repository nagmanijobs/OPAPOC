#!/usr/bin/env python3
"""AWS CDK application for Cloud-native Hello World Lambda with API Gateway and S3."""

import aws_cdk as cdk
from lambda_stack import LambdaStack

app = cdk.App()

# Create the Lambda stack
LambdaStack(app, "HelloWorldLambdaStack", 
    env=cdk.Environment(
        account=cdk.Aws.ACCOUNT_ID,
        region=cdk.Aws.REGION
    ),
    description="Cloud-native Hello World Lambda app connected to API Gateway with S3 storage"
)

app.synth()
