#!/usr/bin/env bash
set -euo pipefail

NETWORK_NAME="${NETWORK_NAME:-taller6-data-platform}"
VOLUME_NAME="${VOLUME_NAME:-taller6-shared-volume}"
DATA_ENG_IMAGE="${DATA_ENG_IMAGE:-taller6/data-eng}"
DATA_ENG_TAG="${DATA_ENG_TAG:-latest}"
DATA_SCI_IMAGE="${DATA_SCI_IMAGE:-taller6/data-science}"
DATA_SCI_TAG="${DATA_SCI_TAG:-latest}"

printf '🔄 Creando red %s (si no existe)\n' "$NETWORK_NAME"
docker network create "$NETWORK_NAME" >/dev/null 2>&1 || true

printf '💾 Creando volumen %s (si no existe)\n' "$VOLUME_NAME"
docker volume create "$VOLUME_NAME" >/dev/null 2>&1 || true

printf '\n🚀 Lanzando data-eng manualmente\n'
docker run -d \
  --name data-eng-manual \
  --network "$NETWORK_NAME" \
  --volume "${VOLUME_NAME}:/data/shared" \
  --publish 8080:8080 \
  "${DATA_ENG_IMAGE}:${DATA_ENG_TAG}" >/dev/null

printf '🚀 Lanzando data-science manualmente\n'
docker run -d \
  --name data-science-manual \
  --network "$NETWORK_NAME" \
  --volume "${VOLUME_NAME}:/data/shared" \
  --publish 8888:8888 \
  "${DATA_SCI_IMAGE}:${DATA_SCI_TAG}" >/dev/null

echo "✅ Contenedores manuales en ejecución. Usa 'docker ps' para verificarlos."
