#Terraform v1.9.4 || Terraform 0.13 and later
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.65.0"
    }
  }
  required_version = "1.13.1"
}

provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0aedf6b1cb669b4c7"
  instance_type = "t2.medium"
  key_name      = "test2"
  # Configuration du volume racine avec 100 Go
  root_block_device {
    volume_size = 100
    volume_type = "gp3"
    encrypted   = true
    delete_on_termination = true
    tags = {
      Name = "pwd2-root-volume"
    }
  }
  tags = {
    Name = "pwd2"
  }
}
