####################
# VARIABLES
####################

# authenticate IAM user
variable "aws_access_key" {}
variable "aws_secret_key" {}

# key_name locates public key on AWS, private_key_path locates private key on client
variable "key_name" {}
variable "private_key_path" {}

####################
# PROVIDERS
####################

provider "aws" {
  # authenticate IAM user
  access_key      = "${var.aws_access_key}"
  secret_key      = "${var.aws_secret_key}"
  # region in which provider resources will be created
  region          = "us-east-1"
}

####################
# RESOURCES
####################

# note syntax: TF keyword ('resource') args ('aws_security_group') TF name ('ssh_only')
resource "aws_security_group" "ssh_only" {
  
  # name, description for AWS (vs. TF name lines 29-30 for TF string interpolation)
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
    private_key   = "${file(var.private_key_path)}"
  }

  # file provisioner lacks permissions to write directly to /usr/share/nginx/html, so write to /tmp first...
  provisioner "file" {
    source        = "index.html"
    destination   = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    inline = [
       # '-y' flag for preemptive prompt to yum update request
      "sudo yum install nginx -y",
      # ...then cp from tmp to nginx
      "sudo cp /tmp/index.html /usr/share/nginx/html/index.html",
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
