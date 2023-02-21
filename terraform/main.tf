terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "terraform_state_backend" {
  source           = "cloudposse/tfstate-backend/aws"
  version          = "0.38.1"
  name             = "engiqueer"
  dynamodb_enabled = false

  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy                      = false
}
