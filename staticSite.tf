####################
# VARIABLES
####################

# authenticate IAM user
variable "aws_access_key" {}
variable "aws_secret_key" {}

# public key on AWS, private key on client
variable "key_name" {}
variable "private_key_path" {}

# sg
variable "security_group_id" {}

####################
# DATA
####################

# data "aws_security_group" "selected" {
#   id = "${var.security_group_id}"
# }

####################
# PROVIDERS
####################

provider "aws" {
  # authenticate IAM user
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-2"
}

####################
# RESOURCES
####################

# https://www.terraform.io/docs/providers/aws/d/security_group.html
# resource "aws_subnet" "subnet" {
#   vpc_id     = "${data.aws_security_group.selected.vpc_id}"
#   cidr_block = "10.0.1.0/24"
# }

resource "aws_instance" "nginxServer" {
  # this AMI specific to us-east-2
  ami           = "ami-3883a55d"
  instance_type = "t2.micro"
  key_name      = "${var.key_name}"

  connection {
    # default user for all EC2 instances
    user        = "ec2-user"
    timeout     = "30s"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      # - y for preemptive prompt to yum update request
      "sudo yum install nginx -y",
      "sudo service nginx start"
    ]
  }
}

####################
# OUTPUT
####################

output "dns" {
    value = "${aws_instance.nginxServer.public_dns}"
}
