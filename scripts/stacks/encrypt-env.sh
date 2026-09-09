#!/bin/bash
set -euo pipefail

STACKS_DIRECTORY="docker/stacks"

encrypt_stack_env() {
    local stack_directory="$1"

    if [ ! -f "$stack_directory/.env" ]; then
        echo "⚠️ Warning: $stack_directory doesn't have .env file. Skipping..."
        return 0
    fi

    sops encrypt "$stack_directory/.env" >"$stack_directory/.enc.env"
}

if [ $# -gt 0 ]; then
    stack_directory="$STACKS_DIRECTORY/$1"

    if [ -d "$stack_directory" ]; then
        encrypt_stack_env "$stack_directory"
    fi

    echo "⛔️ Error: $stack_directory doesn't exist. Aborting..."
    exit 1
else
    for stack_directory in "$STACKS_DIRECTORY"/*; do
        encrypt_stack_env "$stack_directory"
    done
fi

clear
echo "🔒 Encrypted successfully!"
