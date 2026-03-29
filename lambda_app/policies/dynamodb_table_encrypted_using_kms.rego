package aws.cfn.dynamodbTableEncryptedKms

default allow = false

allow {
    resource := input.Resources[_]
    dynamodbTableresource(resource)
    dynamodbTableEncryptedKms(resource)
}

dynamodbTableresource(resource) {
    resource.Type == "AWS::DynamoDB::Table"
}

dynamodbTableEncryptedKms(resource) {
    resource.Properties.SSESpecification["KMSMasterKeyId"]
}

deny_message [msg]{
    not allow
    msg := "https://docs.aws.amazon.com/config/latest/developerguide/dynamodb-table-encrypted-kms.html"
}
