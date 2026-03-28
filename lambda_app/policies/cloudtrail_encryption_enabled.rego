package aws.cfn.cloudTrailEncryptionEnabled

default allow = false

allow {
    resource := input.Resources[_]
    cloudTrailresource(resource)
    cloudTrailEncryptionEnabled(resource)
}

cloudTrailresource(resource) {
    resource.Type == "AWS::CloudTrail::Trail"
}

cloudTrailEncryptionEnabled(resource) {
    resource.Properties["KMSKeyId"]
}

deny_message [msg]{
    not allow
    msg := "https://docs.aws.amazon.com/config/latest/developerguide/cloud-trail-encryption-enabled.html"
}
