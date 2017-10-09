####################
# VARIABLES
####################

# authenticate IAM user
variable "aws_access_key" {}
variable "aws_secret_key" {}

# public key on AWS, private key on client
variable "key_name" {}
variable "private_key_path" {}