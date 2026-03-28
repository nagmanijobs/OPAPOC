package aws.cfn.rotationCustomerCreatedCmksEnabled

default allow = false

allow {
    rotationCustomerCreatedCmksEnabled
}

rotationCustomerCreatedCmksEnabled [msg]{
    resource := input.Resources[_]
    resource.Type == "AWS::KMS::Key"
    resource.Properties.EnableKeyRotation == true
    msg := "https://docs.aws.amazon.com/kms/latest/developerguide/rotate-keys.html"
}
