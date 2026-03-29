package aws.cfn.iamPasswordPolicyPasswordReusePrevention

default allow = false

passwordreuseprevention = 24

allow {
    iamPasswordPolicyPasswordReusePrevention
}

iamPasswordPolicyPasswordReusePrevention[msg] {
    resource := input.Resources[_]
    resource.Type == "AWS::IAM::AccountPasswordPolicy"
    resource.Properties.PasswordReusePrevention == passwordreuseprevention
    msg := "https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_passwords_account-policy.html"
}
