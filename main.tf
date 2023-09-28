terraform {
  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = "~> 5.0"
    }
  }
}


variable "app_name" {
  default = "bennun-terraform-example"
  description = "Name of the Heroku app provisioned as an example"
}

resource "heroku_app" "bennun-app-terraform" {
  name   = var.app_name
  region = "us"
}