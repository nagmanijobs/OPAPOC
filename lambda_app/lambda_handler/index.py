"""Lambda handler for Hello World application with login information storage."""

import json
import boto3
import os
from datetime import datetime
from typing import Any, Dict

# Initialize S3 client
s3_client = boto3.client("s3")

# Get S3 bucket name from environment variable
LOGIN_BUCKET = os.environ.get("LOGIN_BUCKET", "")


def handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Lambda handler function for Hello World API.
    
    Supports:
    - GET /hello: Returns a simple hello world response
    - POST /hello: Returns hello with custom name
    - POST /login: Stores login information to S3
    """
    
    try:
        # Extract HTTP method and path
        http_method = event.get("httpMethod", "GET")
        path = event.get("path", "/")
        
        print(f"Received request: {http_method} {path}")
        
        # Handle GET /hello
        if http_method == "GET" and path == "/hello":
            return handle_hello_get()
        
        # Handle POST /hello
        elif http_method == "POST" and path == "/hello":
            return handle_hello_post(event)
        
        # Handle POST /login
        elif http_method == "POST" and path == "/login":
            return handle_login(event)
        
        # Handle 404
        else:
            return {
                "statusCode": 404,
                "body": json.dumps({"message": "Endpoint not found"}),
                "headers": {"Content-Type": "application/json"},
            }
    
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": f"Internal server error: {str(e)}"}),
            "headers": {"Content-Type": "application/json"},
        }


def handle_hello_get() -> Dict[str, Any]:
    """Handle GET /hello request."""
    response = {
        "message": "Hello, World!",
        "timestamp": datetime.utcnow().isoformat(),
        "service": "Cloud-Native Lambda App"
    }
    
    return {
        "statusCode": 200,
        "body": json.dumps(response),
        "headers": {"Content-Type": "application/json"},
    }


def handle_hello_post(event: Dict[str, Any]) -> Dict[str, Any]:
    """Handle POST /hello request with custom name."""
    try:
        body = json.loads(event.get("body", "{}"))
        name = body.get("name", "Guest")
        
        response = {
            "message": f"Hello, {name}!",
            "timestamp": datetime.utcnow().isoformat(),
            "service": "Cloud-Native Lambda App"
        }
        
        return {
            "statusCode": 200,
            "body": json.dumps(response),
            "headers": {"Content-Type": "application/json"},
        }
    except json.JSONDecodeError:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Invalid JSON in request body"}),
            "headers": {"Content-Type": "application/json"},
        }


def handle_login(event: Dict[str, Any]) -> Dict[str, Any]:
    """Handle POST /login request and store credentials to S3."""
    try:
        body = json.loads(event.get("body", "{}"))
        
        # Extract login credentials
        username = body.get("username")
        password = body.get("password")
        
        if not username or not password:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Username and password are required"}),
                "headers": {"Content-Type": "application/json"},
            }
        
        if not LOGIN_BUCKET:
            return {
                "statusCode": 500,
                "body": json.dumps({"error": "Login bucket not configured"}),
                "headers": {"Content-Type": "application/json"},
            }
        
        # Create login record
        timestamp = datetime.utcnow().isoformat()
        login_record = {
            "username": username,
            "password": password,
            "timestamp": timestamp,
            "ip_address": event.get("requestContext", {}).get("identity", {}).get("sourceIp", "unknown"),
        }
        
        # Store to S3
        s3_key = f"logins/{timestamp}-{username}.json"
        s3_client.put_object(
            Bucket=LOGIN_BUCKET,
            Key=s3_key,
            Body=json.dumps(login_record),
            ServerSideEncryption="AES256",
            ContentType="application/json"
        )
        
        print(f"Login record stored to S3: {s3_key}")
        
        response = {
            "message": f"Login successful for user {username}",
            "timestamp": timestamp,
            "stored_in_s3": s3_key,
            "notice": "WARNING: Storing plain text passwords is NOT recommended in production. Use authentication services like Cognito."
        }
        
        return {
            "statusCode": 200,
            "body": json.dumps(response),
            "headers": {"Content-Type": "application/json"},
        }
    
    except json.JSONDecodeError:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Invalid JSON in request body"}),
            "headers": {"Content-Type": "application/json"},
        }
    except Exception as e:
        print(f"Error storing login info: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": f"Failed to store login information: {str(e)}"}),
            "headers": {"Content-Type": "application/json"},
        }
