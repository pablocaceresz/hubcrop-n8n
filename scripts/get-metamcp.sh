#!/usr/bin/env bash
set -euo pipefail

TAG="${1:-}"   # opcional: pasa un tag, p.ej: ./scripts/get-metamcp.sh v2.4.13

if [ -d "./metamcp/.git" ]; then
  echo "metamcp ya existe. Actualiza manualmente si quieres cambiar de versión."
  exit 0
fi

echo "Clonando metatool-ai/metamcp..."
git clone https://github.com/metatool-ai/metamcp.git metamcp

if [ -n "$TAG" ]; then
  echo "Cambiando a tag $TAG ..."
  git -C metamcp fetch --tags
  git -C metamcp checkout "$TAG"
fi

echo "Listo. Puedes compilar con: docker compose build metamcp"
