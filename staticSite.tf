####################
# PROVIDERS
####################

provider "aws" {
# authenticate IAM user
  access_key      = "${var.aws_access_key}"
  secret_key      = "${var.aws_secret_key}"
  region          = "us-east-1"
}

####################
# RESOURCES
####################

resource "aws_security_group" "ssh_only" {
  name            = "nginxServer_sg"
  description     = "allow SSH connections"

  ingress {
    from_port     = 22
    to_port       = 22
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# debug for failed yum update led to egress rule [https://stackoverflow.com/questions/20822021/amazon-ec2-instance-cant-update-or-use-yum]
  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "nginxServer" {
# AMI specific to us-east-1
  ami             = "ami-8c1be5f6"
  instance_type   = "t2.micro"
  key_name        = "${var.key_name}"
  security_groups = ["nginxServer_sg"]
  tags {
      Name = "nginxServer"
  }

  connection {
  # default user for all EC2 instances
    user          = "ec2-user"
    timeout       = "30s"
  # private_key = "${file("/Users/zach/Desktop/aws_creds/EC2/ZVregion1Default.pem")}"
  # https://github.com/hashicorp/terraform/issues/9308
    private_key   = "${file(var.private_key_path)}"
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
    value         = "${aws_instance.nginxServer.public_dns}"
}
