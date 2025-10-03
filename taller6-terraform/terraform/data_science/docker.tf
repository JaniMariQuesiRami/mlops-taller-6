terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.2"
    }
  }
}

variable "image_name" {
  type        = string
  description = "Nombre del repositorio Docker de la imagen."
}

variable "image_tag" {
  type        = string
  description = "Tag de la imagen Docker."
}

variable "container_name" {
  type        = string
  description = "Nombre del contenedor que desplegará la imagen."
}

variable "container_port" {
  type        = number
  description = "Puerto que expone el contenedor."
}

variable "context_path" {
  type        = string
  description = "Ruta absoluta al contexto de construcción de Docker."
}

variable "dockerfile_name" {
  type        = string
  description = "Nombre del Dockerfile relativo al contexto."
}

variable "shared_volume_name" {
  type        = string
  description = "Nombre del volumen compartido con ingeniería de datos."
}

variable "shared_network_name" {
  type        = string
  description = "Nombre de la red compartida."
}

locals {
  image_ref   = "${var.image_name}:${var.image_tag}"
  volume_path = "/data/shared"
}

resource "docker_image" "data_science" {
  name = local.image_ref

  build {
    context    = var.context_path
    dockerfile = "${var.context_path}/${var.dockerfile_name}"
  }

  keep_locally = true
}

resource "docker_container" "data_science" {
  name  = var.container_name
  image = docker_image.data_science.image_id

  env = [
    "SHARED_VOLUME_PATH=${local.volume_path}"
  ]

  ports {
    internal = var.container_port
    external = var.container_port
  }

  volumes {
    volume_name    = var.shared_volume_name
    container_path = local.volume_path
    read_only      = false
  }

  networks_advanced {
    name = var.shared_network_name
  }
}

output "image_id" {
  value       = docker_image.data_science.image_id
  description = "ID único de la imagen de ciencia de datos construida por Terraform."
}

output "container_id" {
  value       = docker_container.data_science.id
  description = "ID del contenedor de ciencia de datos desplegado."
}
