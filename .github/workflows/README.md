# CI Workflows

This repository uses CI only. There is no automated deployment workflow.

## Active Workflow

The repository has one GitHub Actions workflow: `build-and-validate.yml`.

It runs on pushes to `main` and `Opa-Testing-Feature`, and on pull requests targeting `main`.

## What CI Checks

- Installs Python dependencies and the AWS CDK CLI
- Validates the Rego bundle with `opa check`
- Synthesizes the CDK stack into CloudFormation JSON
- Evaluates every synthesized template against every policy in `lambda_app/policies`
- Runs a small Lambda handler smoke test
- Uploads synthesized templates and a validation report as artifacts

## Blocking Behavior

OPA validation is blocking.

If any policy returns `deny_message` for the synthesized template, the workflow exits non-zero and the pull request should fail once the branch protection rule requires the workflow check.

## Branch Protection

In GitHub branch protection for `main`, require the `ci` job from `build-and-validate.yml` before merge.

## Why Not Conftest

The current policy files are authored around `allow` and `deny_message` rules and are directly compatible with OPA evaluation.

Conftest expects a different rule shape by default, typically `deny`, `warn`, or `violation`. Using Conftest here would require wrapper policies or a rewrite of the existing Rego bundle.

## Local Validation

From `lambda_app`:

```bash
python -m pip install -r requirements.txt
npm install -g aws-cdk
cd cdk && cdk synth --output cdk.out
cd .. && opa check policies
```

To inspect a single policy manually:

```bash
package=$(awk '/^package / { print $2; exit }' policies/<policy-file>.rego)
opa eval --fail-defined -d policies -d cdk/cdk.out/<template>.template.json "data.${package}.deny_message"
```
