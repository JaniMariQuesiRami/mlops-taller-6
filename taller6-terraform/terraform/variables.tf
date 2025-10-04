variable "docker_network_name" {
  type        = string
  default     = "taller6-data-platform"
  description = "Nombre de la red Docker compartida por los contenedores de datos."
}

variable "docker_volume_name" {
  type        = string
  default     = "taller6-shared-volume"
  description = "Nombre del volumen Docker compartido para intercambio de archivos."
}

variable "data_eng_image_name" {
  type        = string
  default     = "jannisce2508/taller6-data-eng"
  description = "Nombre del repositorio de la imagen para el servicio de ingeniería de datos."
}

variable "data_eng_image_tag" {
  type        = string
  default     = "latest"
  description = "Tag aplicado a la imagen de ingeniería de datos."
}

variable "data_science_image_name" {
  type        = string
  default     = "jannisce2508/taller6-data-science"
  description = "Nombre del repositorio de la imagen para el servicio de ciencia de datos."
}

variable "data_science_image_tag" {
  type        = string
  default     = "latest"
  description = "Tag aplicado a la imagen de ciencia de datos."
}

variable "data_eng_port" {
  type        = number
  default     = 8080
  description = "Puerto expuesto por el contenedor de ingeniería de datos."
}

variable "data_science_port" {
  type        = number
  default     = 8888
  description = "Puerto expuesto por el contenedor de ciencia de datos."
}

variable "data_eng_context" {
  type        = string
  default     = "../docker"
  description = "Ruta relativa al directorio que actúa como contexto de construcción de la imagen de ingeniería de datos."
}

variable "data_science_context" {
  type        = string
  default     = "../docker"
  description = "Ruta relativa al directorio que actúa como contexto de construcción de la imagen de ciencia de datos."
}

variable "data_eng_container_name" {
  type        = string
  default     = "data-eng-service"
  description = "Nombre del contenedor desplegado para el servicio de ingeniería de datos."
}

variable "data_science_container_name" {
  type        = string
  default     = "data-science-service"
  description = "Nombre del contenedor desplegado para el servicio de ciencia de datos."
}
