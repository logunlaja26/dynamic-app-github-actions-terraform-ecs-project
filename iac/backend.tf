# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "lyomann-terraform-remote-state"
    key            = "rentzone-app/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terrraform-state-lock"
  }
}
