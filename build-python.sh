#!/usr/bin/env bash

# Exit on error
set -e

echo "Building sandbox container images..."

# Determine container command (docker or podman)
if [ "$1" == "docker" ] || [ "$1" == "podman" ]; then
    CONTAINER_CMD=$1
    echo "Using provided container command: $CONTAINER_CMD"
else
    echo "Checking for available container command (podman/docker)..."
    # Check if we're using podman or docker
    if command -v podman &> /dev/null; then
        CONTAINER_CMD=podman
    elif command -v docker &> /dev/null; then
        CONTAINER_CMD=docker
    else
        echo "Error: Neither podman nor docker found, and no valid command provided."
        echo "Usage: $0 [docker|podman]"
        exit 1
    fi
fi

echo "Using $CONTAINER_CMD for container operations."

# Build base image
echo "Building base sandbox image..."
$CONTAINER_CMD build -t novel-code-sandbox-base:latest -f Containerfile.base .

# Build Python image with verbose output
echo "Building Python sandbox image..."
$CONTAINER_CMD build --progress=plain -t novel-code-sandbox:latest -f Containerfile.python .

echo "Container images built successfully!"
echo ""
echo "You can run the Python sandbox with:"
echo "$CONTAINER_CMD run -it --rm -v \$(pwd)/tasks:/sandbox/tasks novel-code-sandbox:latest"