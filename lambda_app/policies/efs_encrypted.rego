package aws.cfn.efsEncryptedCheck

default allow = false

allow {
    efsEncryptedCheck
}

efsEncryptedCheck[msg]{
    resource := input.Resources[_]
    resource.Type == "AWS::EFS::FileSystem"
    resource.Properties.Encrypted == true
    resource.Properties["KmsKeyId"]
    msg := "https://docs.aws.amazon.com/config/latest/developerguide/efs-encrypted-check.html"
}
