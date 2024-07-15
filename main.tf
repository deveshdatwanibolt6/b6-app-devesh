terraform {
  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = "~> 5.0"
    }
  }
}

variable "app_name_v2" {
  description = "Name of the Heroku app provisioned as an example"
}

resource "heroku_app" "app_name" {
  name   = var.app_name_v2
  region = "us"
}

# Build code & release to the app
resource "heroku_build" "app_name" {
  app_id     = heroku_app.b6-app.id
  buildpacks = ["https://github.com/heroku/heroku-buildpack-python.git"]
}

# Launch the app's web process by scaling-up
resource "heroku_formation" "app_name" {
  app_id     = heroku_app.app_name.id
  type       = "web"
  quantity   = 1
  size       = "Standard-1x"
  depends_on = [heroku_build.b6-app]
}

output "example_app_url" {
  value = heroku_app.app_name.web_url
}