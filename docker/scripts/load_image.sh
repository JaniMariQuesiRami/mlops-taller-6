#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Uso: $0 <archivo_imagen.tar>" >&2
  exit 1
fi

ARCHIVE="$1"

if [[ ! -f "$ARCHIVE" ]]; then
  echo "El archivo $ARCHIVE no existe." >&2
  exit 1
fi

printf '📦 Cargando imagen desde %s\n' "$ARCHIVE"
docker load -i "$ARCHIVE"
echo "✅ Imagen importada en el daemon local."
