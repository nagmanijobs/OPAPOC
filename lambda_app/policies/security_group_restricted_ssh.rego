package aws.cfn.secgroupRestrictedSsh

default allow = false

allow {
    secgroupRestrictedSsh
}

secgroupRestrictedSsh{
    resource := input.Resources[_]
    resource.Type == "AWS::EC2::SecurityGroup"
    resource.Properties.SecurityGroupIngress[_].FromPort == 22
    resource.Properties.SecurityGroupIngress[_].CidrIp != "0.0.0.0/0"
}
