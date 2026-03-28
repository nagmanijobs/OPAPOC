package aws.cfn.rdsInstancePublicAccessCheck

default allow = false

allow {
    rdsInstancePublicAccessCheck
}

rdsInstancePublicAccessCheck [msg]{
    resource := input.Resources[_]
    resource.Type == "AWS::RDS::DBInstance"
    resource.Properties.PubliclyAccessible == false
    msg := "https://docs.aws.amazon.com/config/latest/developerguide/rds-instance-public-access-check.html"
}
