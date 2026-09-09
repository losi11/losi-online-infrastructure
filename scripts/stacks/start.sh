#!/bin/bash
set -euo pipefail

STACKS_DIRECTORY="docker/stacks"

start_stack() {
    local stack_directory="$1"

    (cd "$stack_directory" && docker compose up -d)

    case "$stack_directory" in
    *beszel)
        sudo tailscale serve --bg --https=8090 http://localhost:8090
        ;;
    esac
}

if [ $# -gt 0 ]; then
    stack_directory="$STACKS_DIRECTORY/$1"

    if [ -d "$stack_directory" ]; then
        start_stack "$stack_directory"
    fi

    echo "⛔️ Error: $stack_directory doesn't exist. Aborting..."
    exit 1
else
    for stack_directory in "$STACKS_DIRECTORY"/*; do
        start_stack "$stack_directory"
    done
fi

clear
echo "✅ Started successfully!"
