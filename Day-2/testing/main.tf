
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami = var.ec2_ami
  instance_type = var.ec2_type
}
