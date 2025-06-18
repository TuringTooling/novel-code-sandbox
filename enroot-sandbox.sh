#!/bin/bash

# Enroot Sandbox Wrapper Script
# This script properly configures the environment to avoid host filesystem conflicts

set -e

# Default values
TASKS_DIR="$(pwd)/../tasks"
CONTAINER_NAME="ms-novel-code-sandbox"
COMMAND="/bin/bash"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --tasks-dir)
            TASKS_DIR="$2"
            shift 2
            ;;
        --container)
            CONTAINER_NAME="$2"
            shift 2
            ;;
        --command)
            COMMAND="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --tasks-dir DIR    Directory to mount as /tasks (default: ../tasks)"
            echo "  --container NAME   Container name (default: ms-novel-code-sandbox)"
            echo "  --command CMD      Command to run (default: /bin/bash)"
            echo "  -h, --help         Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Ensure tasks directory exists
mkdir -p "$TASKS_DIR"

# Create cache directories if they don't exist
mkdir -p "$TASKS_DIR/.uv_cache"
mkdir -p "$TASKS_DIR/.uv_data"
mkdir -p "$TASKS_DIR/.python_user"

echo "Starting Enroot container with isolated environment..."
echo "Tasks directory: $TASKS_DIR"
echo "Container: $CONTAINER_NAME"
echo "Command: $COMMAND"
echo ""

# Start Enroot with proper environment isolation
exec enroot start \
  --mount "$TASKS_DIR:/tasks" \
  --env UV_CACHE_DIR=/tasks/.uv_cache \
  --env UV_DATA_DIR=/tasks/.uv_data \
  --env PYTHONUSERBASE=/tasks/.python_user \
  --env HOME=/tasks \
  --env TMPDIR=/tasks/.tmp \
  "$CONTAINER_NAME" -- "$COMMAND"