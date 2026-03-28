package aws.cfn.s3BucketLevelPublicAccessProhibited

default allow = false

allow {
    s3BucketLevelPublicAccessProhibited
}

s3BucketLevelPublicAccessProhibited [msg]{
    resource := input.Resources[_]
    resource.Type == "AWS::S3::Bucket"
    resource.Properties.BlockPublicAcls == true
    resource.Properties.IgnorePublicAcls == true
    resource.Properties.BlockPublicPolicy == true
    resource.Properties.RestrictPublicBuckets == true
    msg := "https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-level-public-access-prohibited.html"
}
