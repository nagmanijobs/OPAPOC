package aws.cfn.s3BucketLevelPublicAccessProhibitedSingleBucket

default allow = false

allow {
    s3BucketLevelPublicAccessProhibitedSingleBucket
}

s3BucketLevelPublicAccessProhibitedSingleBucket [msg]{
    resource := input.Resources[_]
    resource.Type == "AWS::S3::AccountPublicAccessBlock"
    resource.Properties.BlockPublicAcls == true
    resource.Properties.BlockPublicAcls == true
    resource.Properties.BlockPublicAcls == true
    resource.Properties.BlockPublicAcls == true
    msg := "https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-level-public-access-prohibited.html"
}
