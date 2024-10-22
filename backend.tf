terraform {
  backend "s3" {
    bucket = "dhanikaa-remote-backend"
    region = "eu-north-1"
    key = "terraform.tfstate"
  }
}