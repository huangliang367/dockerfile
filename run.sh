#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
IMAGE_NAME="${IMAGE_NAME:-qemu-arm64-build}"
TAG="${TAG:-latest}"

echo "[*] Starting Docker container: ${IMAGE_NAME}:${TAG}"
echo "    Host workspace: ${PROJECT_ROOT} -> /workspace"
docker run -it --rm --privileged \
    --user hl \
    --dns 8.8.8.8 \
    --dns 114.114.114.114 \
    -v "${PROJECT_ROOT}:/workspace" \
    -w /workspace \
    "${IMAGE_NAME}:${TAG}"
