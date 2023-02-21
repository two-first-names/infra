terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "engiqueer"
    key            = "terraform.tfstate"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
