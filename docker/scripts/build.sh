#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

DATA_ENG_IMAGE="${DATA_ENG_IMAGE:-taller6/data-eng}"
DATA_ENG_TAG="${DATA_ENG_TAG:-latest}"
DATA_SCI_IMAGE="${DATA_SCI_IMAGE:-taller6/data-science}"
DATA_SCI_TAG="${DATA_SCI_TAG:-latest}"

printf '🛠  Construyendo imagen de ingeniería de datos (%s:%s)\n' "$DATA_ENG_IMAGE" "$DATA_ENG_TAG"
docker build \
  --file "${DOCKER_DIR}/Dockerfile.data-eng" \
  --tag "${DATA_ENG_IMAGE}:${DATA_ENG_TAG}" \
  "${DOCKER_DIR}"

printf '\n🛠  Construyendo imagen de ciencia de datos (%s:%s)\n' "$DATA_SCI_IMAGE" "$DATA_SCI_TAG"
docker build \
  --file "${DOCKER_DIR}/Dockerfile.data-science" \
  --tag "${DATA_SCI_IMAGE}:${DATA_SCI_TAG}" \
  "${DOCKER_DIR}"

echo "✅ Imágenes construidas."
