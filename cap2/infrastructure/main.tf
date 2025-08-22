terraform {
  required_providers {
    aws = {
      source    = "hashicorp/aws"
      version   = "6.9.0"
    }
  }
}

provider "aws" {
  region        = "us-east-2"
}

data "aws_ami" "ubuntu" {
  most_recent   = true

  filter {
    name        = "name"
    values      = ["al2023-ami-*-kernel-6.1-x86_64"]
  }

  filter {
    name        = "virtualization-type"
    values      = ["hvm"]
  }

  owners        = ["amazon"]
}

resource "aws_instance" "ansible_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [ aws_security_group.ssh_access.id ]

  key_name      = "aws_ssh" 

  tags = {
    Name        = "machine-ansible"
  }
}

# Its important to ssh conections
resource "aws_security_group" "ssh_access" {
  name        = "allow-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id 

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

# Default VPC
data "aws_vpc" "default" {
  default = true
}


output "dns" {
  value = aws_instance.ansible_instance.public_dns
  description = "The public dns to access the instance"
}