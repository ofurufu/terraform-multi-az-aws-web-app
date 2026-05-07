terraform {
  backend "s3" {
    bucket       = "tf-state-webapp-501883958979"
    key          = "webapp/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
  }
}