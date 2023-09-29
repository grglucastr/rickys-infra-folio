terraform {
  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = "~> 5.0"
    }
  }
}

resource "heroku_app" "bennun_app" {
  name   = var.bennun_app_name
  region = var.region
}

resource "heroku_build" "bennun_app_build" {
  app_id = heroku_app.bennun_app.id
  buildpacks = [ "https://github.com/heroku/heroku-buildpack-php" ] # as soons as the website has PHP scripts on it

  source {
    path = "./public"
  }
}

resource "heroku_domain" "bennun_app_domain" {
  app_id   = heroku_app.bennun_app.id
  hostname = var.hostname1
}

resource "heroku_domain" "bennun_app_domain2" {
  app_id   = heroku_app.bennun_app.id
  hostname = var.hostname2
}