resource "docker_image" "nginx" {
  name = "nginx:1.25.3"
}

resource "docker_container" "stacknova" {
  image = docker_image.nginx.image_id
  name  = "stacknova-recette"

  ports {
    internal = 80
    external = 8080
  }

  labels {
    label = "env"
    value = "recette"
  }

  labels {
    label = "project"
    value = "stacknova"
  }
}