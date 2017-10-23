SRE CHALLENGE
=========

This Terraform config spins up a simple static site using AWS EC2.

DEPENDENCIES
-------------------------------

Before getting started, you'll need the following:

  - [AWS account](https://aws.amazon.com/account/) 
  - AWS user whose [IAM policy](https://aws.amazon.com/iam/) enables creation of EC2 instances (like AmazonEC2FullAccess)
  - [EC2 key pair] (http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
  - [Terraform CLI](https://www.terraform.io/intro/getting-started/install.html)

EXECUTION
-------------------------------

First, make a `config` directory and put your main TF configuration `staticSite.tf` inside:
```sh
├── config
│   └── staticSite.tf

```

Next, add an HTML asset to the same directory:
```sh
├── config
│   └── staticSite.tf
	└── index.html

```

then store the following:

  - AWS access keys for IAM user
  - EC2 key pair name and path to private key

in a `staticSite.tfvars` file above `config`:
```sh
staticSite.tfvars
├── config
│   └── staticSite.tf
	└── index.html

```

`staticSite.tfvars` stores private values: 
```
aws_access_key = "foo123"
```

`staticSite.tf` uses those values in variables:
```
variable "aws_access_key" {}
```

Finally, run the following:

```sh
$ terraform apply -var-file='../staticSite.tfvars'
```

inside the `config` directory to create your infrastructure!
