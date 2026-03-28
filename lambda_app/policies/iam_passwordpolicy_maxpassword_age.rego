package aws.cfn.iamPasswordPolicyMaxPasswordAge

default allow = false

allow {
    iamPasswordPolicyMaxPasswordAge
}

iamPasswordPolicyMaxPasswordAge[msg]{
    resource := input.Resources[_]
    resource.Type == "AWS::IAM::AccountPasswordPolicy"
    resource.Properties.MaxPasswordAge < 90
    msg := "https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_passwords_account-policy.html"
}
