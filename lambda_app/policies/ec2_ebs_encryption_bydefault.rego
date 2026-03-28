package aws.cfn.ec2EbsEncryptionByDefault

default allow = false

allow {
    resource := input.Resources[_]
    isEC2EbsEncryptionByDefaultResource(resource)
    isEbsEncryptionByDefaultCondition(resource.Properties.EbsEncryptionByDefault)
}

isEC2EbsEncryptionByDefaultResource(resource) {
    resource.Type == "AWS::EC2::EbsEncryptionByDefault"
}

isEbsEncryptionByDefaultCondition(ebsEncryptionByDefault) {
    ebsEncryptionByDefault == true
}

deny_message [msg]{
    not allow
    msg := "https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSEncryption.html"
}
