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

resource "heroku_app" "bennun_app_terraform" {
  name   = var.app_name
  region = "us"
}

resource "heroku_build" "bennun_app_build" {
  app_id = heroku_app.bennun_app_terraform.id
  buildpacks = [ "https://github.com/heroku/heroku-buildpack-php" ]

  source {
    # A local directory, changing its contents will
    # force a new build during `terraform apply`
    path = "./public"
  }
}

resource "heroku_formation" "bennun_formation" {
  app_id     = heroku_app.bennun_app_terraform.id
  type       = "web"
  quantity   = 1
  size       = "eco"
  depends_on = ["heroku_build.bennun_app_build"]
}