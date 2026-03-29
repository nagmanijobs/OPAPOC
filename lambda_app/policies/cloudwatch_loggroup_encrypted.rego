package aws.cfn.cloudWatchLogGroupEncrypted

default allow = false

allow {
    resource := input.Resources[_]
    cloudWatchresource(resource)
    cloudWatchLogGroupEncrypted(resource)
}

cloudWatchresource(resource) {
    resource.Type == "AWS::Logs::LogGroup"
}

cloudWatchLogGroupEncrypted(resource) {
    resource.Properties["KmsKeyId"]
}

deny_message [msg]{
    not allow
    msg := "https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html"
}
