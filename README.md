# ECS-cluster

## Quick start

The values in "vars.tf" can be changed to configure differently the cluster.

The environment variables:

  * AWS_SECRET_ACCESS_KEY
  * AWS_ACCESS_KEY_ID

must be defined so Terraform can connect to AWS. Then the usual 3 commands must be run to create the infrastruture:

```
terraform init
terraform plan -out plan
terraform apply "plan"
```

As this is a demo remember to run the destroy afterwards:

```
terraform destroy
```

## Configuration

The values in "vars.tf" can be changed to configure the cluster.
