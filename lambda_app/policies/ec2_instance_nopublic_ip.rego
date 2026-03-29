package aws.cfn.ec2InstanceNoPublicIp

default allow = false

allow {
    resource := input.Resources[_]
    ec2Instanceresource(resource)
    ec2InstanceNoPublicIp(resource)
}

ec2Instanceresource(resource) {
    resource.Type == "AWS::EC2::Instance"
}

ec2InstanceNoPublicIp(resource) {
    resource.Properties.NetworkInterfaces[_].AssociatePublicIpAddress == false
}

deny_message [msg]{
    not allow
    msg := "https://docs.aws.amazon.com/config/latest/developerguide/ec2-instance-no-public-ip.html"
}
