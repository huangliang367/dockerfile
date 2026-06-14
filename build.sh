#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMAGE_NAME="${IMAGE_NAME:-qemu-arm64-build}"
TAG="${TAG:-latest}"

FULL_IMAGE="${IMAGE_NAME}:${TAG}"

# Use sudo for Docker if needed
if ! docker info >/dev/null 2>&1; then
    DOCKER_CMD="sudo docker"
else
    DOCKER_CMD="docker"
fi

# Check if image already exists locally
if ${DOCKER_CMD} images --format '{{.Repository}}:{{.Tag}}' | grep -q "^${FULL_IMAGE}$"; then
    echo "[*] Docker image already exists: ${FULL_IMAGE}"
    echo "    To force rebuild, run: ${DOCKER_CMD} build -t ${FULL_IMAGE} ${SCRIPT_DIR}"
    exit 0
fi

echo "[*] Building Docker image: ${FULL_IMAGE}"
${DOCKER_CMD} build -t "${FULL_IMAGE}" "${SCRIPT_DIR}"

echo "[*] Docker image built successfully: ${FULL_IMAGE}"
