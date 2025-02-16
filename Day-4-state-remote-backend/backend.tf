terraform {
  backend "s3" {
    bucket = "terrastatefiledamu"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

