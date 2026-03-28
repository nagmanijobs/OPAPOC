package aws.cfn.iamPasswordPolicyRequireSymbols

default allow = false

allow {
    iamPasswordPolicyRequireSymbols
}

iamPasswordPolicyRequireSymbols[msg] {
    resource := input.Resources[_]
    resource.Type == "AWS::IAM::AccountPasswordPolicy"
    resource.Properties.RequireSymbols == true
    msg := "https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_passwords_account-policy.html"
}
