#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 3 ]]; then
  echo "Uso: $0 <imagen> [tag] [archivo_salida.tar]" >&2
  exit 1
fi

IMAGE="$1"
TAG="${2:-latest}"
OUTPUT_FILE="${3:-${IMAGE##*/}-${TAG}.tar}"

printf '💽 Guardando imagen %s:%s en %s\n' "$IMAGE" "$TAG" "$OUTPUT_FILE"
docker save -o "$OUTPUT_FILE" "${IMAGE}:${TAG}"
echo "✅ Archivo listo para compartir de forma offline."
