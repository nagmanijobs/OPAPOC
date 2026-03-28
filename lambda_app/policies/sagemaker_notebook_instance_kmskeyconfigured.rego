package aws.cfn.sagemakerNotebookInstanceKmsKeyConfigured

default allow = false

allow {
    sagemakerNotebookInstanceKmsKeyConfigured
}

sagemakerNotebookInstanceKmsKeyConfigured [msg] {
    resource := input.Resources[_]
    resource.Type == "AWS::SageMaker::NotebookInstance"
    resource.Properties["KmsKeyId"]
    msg := "https://docs.aws.amazon.com/config/latest/developerguide/sagemaker-notebook-instance-kms-key-configured.html"
}
