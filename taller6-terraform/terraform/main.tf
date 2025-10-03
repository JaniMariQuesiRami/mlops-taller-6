locals {
  data_eng_context_path     = abspath("${path.module}/${var.data_eng_context}")
  data_science_context_path = abspath("${path.module}/${var.data_science_context}")
}

resource "docker_network" "data_platform" {
  name = var.docker_network_name
}

resource "docker_volume" "shared_storage" {
  name = var.docker_volume_name
}

module "data_eng" {
  source = "./data_eng"

  image_name          = var.data_eng_image_name
  image_tag           = var.data_eng_image_tag
  container_name      = var.data_eng_container_name
  container_port      = var.data_eng_port
  context_path        = local.data_eng_context_path
  dockerfile_name     = "Dockerfile.data-eng"
  shared_volume_name  = docker_volume.shared_storage.name
  shared_network_name = docker_network.data_platform.name
}

module "data_science" {
  source = "./data_science"

  image_name          = var.data_science_image_name
  image_tag           = var.data_science_image_tag
  container_name      = var.data_science_container_name
  container_port      = var.data_science_port
  context_path        = local.data_science_context_path
  dockerfile_name     = "Dockerfile.data-science"
  shared_volume_name  = docker_volume.shared_storage.name
  shared_network_name = docker_network.data_platform.name
}
