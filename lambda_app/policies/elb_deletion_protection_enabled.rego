package aws.cfn.elbDeletionProtectionEnabled

default allow = false

allow {
    elbDeletionProtectionEnabled
}

elbDeletionProtectionEnabled[msg]{
    resource := input.Resources[_]
    resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
    resource.Properties.LoadBalancerAttributes[_].Key == "deletion_protection.enabled"
    resource.Properties.LoadBalancerAttributes[_].Value == true
    msg := "https://docs.aws.amazon.com/config/latest/developerguide/elb-deletion-protection-enabled.html"
}
