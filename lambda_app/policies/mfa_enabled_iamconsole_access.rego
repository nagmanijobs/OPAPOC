package aws.cfn.mfaEnabledForIamConsoleAccess

default allow = false

allow {
    mfaEnabledForIamConsoleAccess
}

mfaEnabledForIamConsoleAccess [msg]{
    resource := input.Resources[_]
    resource.Type == "AWS::IAM::MFADevice"
    resource.Properties[_] == "AuthenticationCode1"
    resource.Properties[_] == "AuthenticationCode2"
    msg := "https://docs.aws.amazon.com/config/latest/developerguide/mfa-enabled-for-iam-console-access.html"
}
