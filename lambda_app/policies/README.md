# Rego Policy Files (NIST 800-53 Compliance)

This directory contains OPA (Open Policy Agent) Rego policies for AWS CloudFormation compliance validation based on NIST 800-53 security controls.

## Overview

These policies are used to enforce security best practices and compliance requirements for AWS resources defined in CloudFormation templates. Each policy file validates specific security controls.

## Policies Included

### Encryption Policies
- **api_gwcache_encrypted.rego** - Validates API Gateway cache encryption
- **cloudtrail_encryption_enabled.rego** - Ensures CloudTrail encryption with KMS
- **cloudwatch_loggroup_encrypted.rego** - Validates CloudWatch Logs encryption with KMS
- **dynamodb_table_encrypted_using_kms.rego** - Ensures DynamoDB encryption with customer-managed KMS keys
- **ebs_volume_delete_on_termination.rego** - Validates EBS volume termination behavior
- **ec2_ebs_encryption_bydefault.rego** - Ensures EC2 EBS encryption by default
- **efs_encrypted.rego** - Validates EFS encryption with KMS
- **elasticsearch_encrypted_atrest.rego** - Ensures Elasticsearch encryption at rest
- **rotation_customer_created_cmks_enabled.rego** - Validates KMS key rotation

### IAM & Authentication Policies
- **iam_passwordpolicy_maxpassword_age.rego** - Maximum password age < 90 days
- **iam_passwordpolicy_minimum_passwordlength.rego** - Minimum password length of 12 characters
- **iam_passwordpolicy_password_reuse_prevention.rego** - Prevents password reuse
- **iam_passwordpolicy_require_lowercasecharacters.rego** - Requires lowercase characters in passwords
- **iam_passwordpolicy_require_numbers.rego** - Requires numbers in passwords
- **iam_passwordpolicy_require_symbols.rego** - Requires special symbols in passwords
- **iam_passwordpolicy_require_uppercasecharacters.rego** - Requires uppercase characters in passwords
- **maxaccesskeyage.rego** - Validates access key rotation (< 91 days)
- **mfa_enabled_iamconsole_access.rego** - Ensures MFA is enabled for IAM console access

### Network & Access Control Policies
- **elb_deletion_protection_enabled.rego** - Ensures ELB deletion protection
- **ec2_instance_nopublic_ip.rego** - Ensures EC2 instances don't have public IPs
- **rds_instance_public_accesscheck.rego** - Ensures RDS instances are not publicly accessible
- **redshift_cluster_public_accesscheck.rego** - Ensures Redshift clusters are not publicly accessible
- **security_group_restricted_ssh.rego** - Restricts SSH access (port 22) from 0.0.0.0/0

### Data Storage Policies
- **s3bucket_level_public_access_prohibited.rego** - Blocks public access to S3 buckets
- **s3bucket_level_public_access_prohibited_singlebucket.rego** - Account-level S3 public access blocking
- **sagemaker_notebook_instance_kmskeyconfigured.rego** - Ensures SageMaker notebook encryption with KMS

## Usage

### With OPA CLI

```bash
# Evaluate a policy against a CloudFormation template
opa eval -d policies/ -d cloudformation_template.json "input"

# Or with a specific data file
opa eval -d policies/ec2_ebs_encryption_bydefault.rego -d cfn_template.json "data.aws.cfn.ec2EbsEncryptionByDefault.allow"

# Run all policy tests
opa test policies/ -v
```

### Integration with CI/CD

```bash
#!/bin/bash
# Check CloudFormation template against policies

OPA_URL="http://localhost:8181"
TEMPLATE_FILE="cloudformation.yaml"

# Convert YAML to JSON
yq eval -o=json $TEMPLATE_FILE > template.json

# Evaluate against all policies
opa eval -d policies/ -d template.json "data"
```

## Policy Structure

Each Rego policy follows this structure:

```rego
package aws.cfn.<policyName>

default allow = false

allow {
    # Validation logic
    resource := input.Resources[_]
    resource.Type == "AWS::Service::Resource"
    resource.Properties.<Property> == <Value>
}

deny_message [msg]{
    not allow
    msg := "Reference URL to AWS documentation"
}
```

## Compliance Controls

These policies map to the following NIST 800-53 security controls:

- **AC-2**: Account Management
- **AU-4**: Audit Log Storage
- **CM-2**: Baseline Configuration
- **CP-9**: Information System Backup
- **IA-5**: Authentication Mechanisms
- **SC-7**: Boundary Protection
- **SC-13**: Cryptographic Protection
- **SI-7**: Software, Firmware, and Information Integrity

## Running OPA Server

```bash
# Start OPA server
opa run -s

# Load policies
curl -X PUT \
  --data-binary @policies/ec2_ebs_encryption_bydefault.rego \
  http://localhost:8181/v1/policies/ec2_ebs_encryption

# Evaluate
curl -X POST \
  -H "Content-Type: application/json" \
  -d @template.json \
  http://localhost:8181/v1/data/aws/cfn/ec2EbsEncryptionByDefault/allow
```

## Best Practices

1. **Test Policies Locally**: Always test policies against sample CloudFormation templates
2. **Version Control**: Keep policies in version control
3. **Documentation**: Maintain clear documentation for each policy
4. **Regular Updates**: Update policies as AWS releases new features
5. **Monitoring**: Monitor policy violations in CI/CD pipelines

## References

- [OPA Documentation](https://www.openpolicyagent.org/docs/latest/)
- [Rego Language](https://www.openpolicyagent.org/docs/latest/policy-language/)
- [AWS CloudFormation Best Practices](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/best-practices.html)
- [NIST 800-53 Controls](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final)
- [AWS Security Controls](https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html)

## Source

These policies are sourced from the [Rego-CNS](https://github.com/Loginsoft-LLC/Rego-CNS) repository:
https://github.com/Loginsoft-LLC/Rego-CNS/tree/main/aws_cloudformation_nist_800_53

## Contributing

To add new policies:

1. Create a new `.rego` file with a descriptive name
2. Follow the established naming conventions
3. Include comprehensive validation logic
4. Add deny_message with reference URLs
5. Document the policy in this README

## License

These policies are provided as reference implementations for security compliance.
