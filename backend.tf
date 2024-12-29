terraform {

  # required_version = "value"
  backend "s3" {
    bucket = "tfstate1224"
    key = "terraform_state_tf_ga_playback_v2"
    region = "ap-south-1"
    dynamodb_table = "tfstate-locking"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}
