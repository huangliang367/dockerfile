#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMAGE_NAME="${IMAGE_NAME:-qemu-arm64-build}"
TAG="${TAG:-latest}"

echo "[*] Building Docker image: ${IMAGE_NAME}:${TAG}"
docker build -t "${IMAGE_NAME}:${TAG}" "${SCRIPT_DIR}"

echo "[*] Docker image built successfully: ${IMAGE_NAME}:${TAG}"
