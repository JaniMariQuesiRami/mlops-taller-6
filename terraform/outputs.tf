output "network_name" {
  value       = docker_network.data_platform.name
  description = "Nombre de la red Docker creada para la plataforma de datos."
}

output "network_id" {
  value       = docker_network.data_platform.id
  description = "ID de la red Docker creada para la plataforma de datos."
}

output "shared_volume_name" {
  value       = docker_volume.shared_storage.name
  description = "Nombre del volumen Docker compartido."
}

output "data_eng_container_id" {
  value       = module.data_eng.container_id
  description = "ID del contenedor de ingeniería de datos."
}

output "data_science_container_id" {
  value       = module.data_science.container_id
  description = "ID del contenedor de ciencia de datos."
}
