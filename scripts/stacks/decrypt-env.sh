#!/bin/bash
set -euo pipefail

STACKS_DIRECTORY="docker/stacks"

decrypt_stack_env() {
    local stack_directory="$1"

    if [ ! -f "$stack_directory/.enc.env" ]; then
        echo "⚠️ Warning: $stack_directory doesn't have .enc.env file. Skipping..."
        return 0
    fi

    sops decrypt "$stack_directory/.enc.env" >"$stack_directory/.env"
}

if [ $# -gt 0 ]; then
    stack_directory="$STACKS_DIRECTORY/$1"

    if [ -d "$stack_directory" ]; then
        decrypt_stack_env "$stack_directory"
    fi

    echo "⛔️ Error: $stack_directory doesn't exist. Aborting..."
    exit 1
else
    for stack_directory in "$STACKS_DIRECTORY"/*; do
        decrypt_stack_env "$stack_directory"
    done
fi

clear
echo "🔓 Decrypted successfully!"
