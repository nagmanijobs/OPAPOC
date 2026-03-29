package aws.cfn.redshiftClusterPublicAccessCheck

default allow = false

allow {
    redshiftClusterPublicAccessCheck
}

redshiftClusterPublicAccessCheck [msg]{
    resource := input.Resources[_]
    resource.Type == "AWS::Redshift::Cluster"
    resource.Properties.PubliclyAccessible == false
    msg := "https://docs.aws.amazon.com/config/latest/developerguide/redshift-cluster-public-access-check.html"
}
