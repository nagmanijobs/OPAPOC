package aws.cf.iamPasswordPolicyRequireNumbers

default allow = false

allow {
    iamPasswordPolicyRequireNumbers
}

iamPasswordPolicyRequireNumbers[msg] {
    resource := input.Resources[_]
    resource.Type == "AWS::IAM::AccountPasswordPolicy"
    resource.Properties.RequireNumbers == true
    msg := "https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_passwords_account-policy.html"
}
