####################
# PROVIDERS
####################

provider "aws" {
  # authenticate IAM user
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

####################
# RESOURCES
####################

resource "aws_instance" "nginxServer" {
  # this AMI specific to us-east-2
  ami           = "ami-8c1be5f6"
  instance_type = "t2.micro"
  key_name      = "${var.key_name}"
  security_groups= ["launch-wizard-1"]
  tags {
      Name = "tfDemoUpdatedAMI"
  }

  # connection {
  #   # default user for all EC2 instances
  #   user        = "ec2-user"
  #   timeout     = "30s"
  #   private_key = "${file(var.private_key_path)}"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     # - y for preemptive prompt to yum update request
  #     "sudo yum install nginx -y",
  #     "sudo service nginx start"
  #   ]
  # }
}

####################
# OUTPUT
####################

output "dns" {
    value = "${aws_instance.nginxServer.public_dns}"
}
