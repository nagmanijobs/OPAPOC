package aws.cfn.apiGwCacheEncrypted

default allow = false

allow {
    resource := input.Resources[_]
    apiGwresource(resource)
    apiGwCacheEncrypted(resource)
}

apiGwresource(resource) {
    resource.Type == "AWS::EC2::EbsEncryptionByDefault"
}

apiGwCacheEncrypted(resource) {
    resource.Variables.cacheEncryptionEnabled == true
}

deny_message [msg]{
    not allow
    msg := "https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_EnableEbsEncryptionByDefault.html, https://docs.aws.amazon.com/config/latest/developerguide/api-gw-cache-enabled-and-encrypted.html"
}
