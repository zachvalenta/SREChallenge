SRE CHALLENGE
=========

This Terraform config spins up a simple static site using AWS EC2.

DEPENDENCIES
-------------------------------

Before getting started, you'll need the following:

  - [AWS account](https://aws.amazon.com/account/) w/ user whose IAM policy enables creation of EC2 instance
  - [Terraform CLI](https://www.terraform.io/intro/getting-started/install.html)

EXECUTION
-------------------------------

To run this example, store the following:

  - [AWS access keys for user](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) 
  - file path to [key pair for EC2 instance](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair)

in a `staticSite.tfvars` file above the directory holding the `staticSite.tf` configuration file:

```sh
staticSite.tfvars
├── config
│   └── staticSite.tf

```

with values stored in variables: 

```
aws_access_key = "yourAccessKeyHere"
```

matching the variable names in `staticSite.tf`:
```
variable "aws_access_key" {}
```

then run the following from the directory holding your `staticSite.tf` file:

```sh
$ terraform apply -var-file='../staticSite.tfvars'
```
