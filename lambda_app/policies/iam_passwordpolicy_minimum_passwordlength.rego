package aws.cfn.iamPasswordPolicyMinimumPasswordLength

default allow = false

min_password_length = 12

allow {
    iamPasswordPolicyMinimumPasswordLength
}

iamPasswordPolicyMinimumPasswordLength[msg] {
    resource := input.Resources[_]
    resource.Type == "AWS::IAM::AccountPasswordPolicy"
    resource.Properties.MinimumPasswordLength == min_password_length
    msg := "https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_passwords_account-policy.html"
}
