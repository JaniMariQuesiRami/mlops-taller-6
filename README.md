# Taller 6 – Terraform con Docker para ML/Data

## Objetivo
Demostrar cómo aplicar Terraform como IaC para orquestar contenedores Docker que separan responsabilidades de ingeniería y ciencia de datos sobre una red y volumen compartidos.

## Prerrequisitos
- Terraform >= 1.5 instalado
- Docker Engine en modo local
- Acceso a shell con permisos para construir imágenes y gestionar contenedores

## Variables y `terraform.tfvars`
Terraform parametriza nombres de imágenes, tags, puertos, red, volumen y rutas de contexto. Ejemplo rápido de `terraform/terraform.tfvars`:

```hcl
docker_network_name         = "taller6-data-platform"
docker_volume_name          = "taller6-shared-volume"
data_eng_image_name         = "taller6/data-eng"
data_eng_image_tag          = "latest"
data_science_image_name     = "taller6/data-science"
data_science_image_tag      = "latest"
data_eng_port               = 8080
data_science_port           = 8888
data_eng_container_name     = "data-eng-service"
data_science_container_name = "data-science-service"
```

## Pasos con Terraform
1. `cd terraform`
2. `terraform init`
3. `terraform validate`
4. `terraform plan`
5. `terraform apply -auto-approve`
6. Verificar contenedores/red/volumen: `docker ps`, `docker network ls`, `docker volume ls`
7. Consumir servicios: `curl http://localhost:8080/status` y `curl http://localhost:8888/summary`
8. Cuando termines: `terraform destroy -auto-approve`

## Operaciones Docker fuera de Terraform
Scripts en `docker/scripts/` muestran el flujo manual:
- `build.sh` construye ambas imágenes con variables `DATA_ENG_IMAGE`, `DATA_SCI_IMAGE`, etc.
- `run.sh` crea red y volumen, y lanza contenedores manuales para comparación.
- `save_image.sh` y `load_image.sh` empaquetan e importan imágenes sin publicarlas.

## Compartir imágenes sin publicarlas
```bash
./docker/scripts/save_image.sh taller6/data-eng latest taller6-data-eng.tar
./docker/scripts/load_image.sh taller6-data-eng.tar

# Comandos base
docker save -o data-science.tar taller6/data-science:latest
docker load -i data-science.tar
```

## Evidencias sugeridas
- `docker images | grep taller6`
- `docker ps --format 'table {{.Names}}\t{{.Ports}}'`
- `docker network ls | grep taller6`
- `docker volume ls | grep taller6`
- `terraform output`

## Enlaces
- Repositorio en GitHub: https://github.com/JaniMariQuesiRami/mlops-taller-6
- Imagen Docker Data Science: https://hub.docker.com/repository/docker/jannisce2508/taller6-data-science/general
- Imagen Docker Data Eng: https://hub.docker.com/repository/docker/jannisce2508/taller6-data-eng/general
- Documentación del provider Docker: https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs
- Tutorial oficial Terraform + Docker: https://developer.hashicorp.com/terraform/tutorials/docker-get-started

## Conclusiones
IaC facilita reproducibilidad total de entornos de ML porque versiona red, volúmenes e imágenes junto al código. Automatizar despliegues reduce errores manuales y acelera el time-to-data para nuevos equipos. Terraform aporta trazabilidad y revisiones por código para la infraestructura que soporta pipelines. Separar ingeniería y ciencia de datos en contenedores favorece portabilidad y escalabilidad independiente. Declarar todo en código habilita integración con CI/CD para validar y promover entornos consistentes desde desarrollo hasta producción.
