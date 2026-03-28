package aws.cfn.maxAccessKeyAge

default allow = false

maxaccesskeyage = 91

allow {
    maxAccessKeyAge
}

maxAccessKeyAge [msg] {
    resource := input.Resources[_]
    resource.Type == "AWS::IAM::AccountPasswordPolicy"
    resource.Properties.MaxAccessKeyAge < maxaccesskeyage
    msg := "https://docs.aws.amazon.com/config/latest/developerguide/access-keys-rotated.html"
}
