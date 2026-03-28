package aws.cfn.ebsVolumeDeleteOnTermination

default allow = false

allow {
    resource := input.Resources[_]
    ebsVolumeresource(resource)
    ebsVolumeDeleteOnTermination(resource)
}

ebsVolumeresource(resource){
    resource.Type == "AWS::EC2::Instance"
}

ebsVolumeDeleteOnTermination(resource){
    resource.Properties.BlockDeviceMappings[_].Ebs.DeleteOnTermination == true
}

deny_message [msg]{
    not allow
    msg := "https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-deleting-volume.html"
}
