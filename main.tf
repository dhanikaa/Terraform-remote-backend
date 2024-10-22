provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "remote_backend_example" {
  ami = "ami-02db68a01488594c5"  
  instance_type = "t3.micro"
  tags = {
    Name = "remote-backend-example"
  }
}

data "aws_s3_bucket" "existing_backend_bucket" {
  bucket = "dhanikaa-remote-backend"  # Reference the existing bucket
}