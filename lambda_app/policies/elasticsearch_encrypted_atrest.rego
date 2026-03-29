package aws.cfn.elasticsearchEncryptedAtRest

default allow = false

allow {
    elasticsearchEncryptedAtRest
}

elasticsearchEncryptedAtRest[msg] {
    resource := input.Resources[_]
    resource.Type == "AWS::Elasticsearch::Domain"
    resource.Properties.EncryptionAtRestOptions[_].Enabled == true
    msg := "https://docs.aws.amazon.com/config/latest/developerguide/elasticsearch-encrypted-at-rest.html"
}
