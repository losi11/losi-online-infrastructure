STACKS_DIRECTORY := "stacks"

alias dec := decrypt
alias enc := encrypt

decrypt stack='':
    #!/bin/bash
    set -euo pipefail

    STACKS_DIRECTORY="{{STACKS_DIRECTORY}}"

    decrypt_stack_env() {
        local stack_directory="$1"

        if [ ! -f "$stack_directory/.enc.env" ]; then
            echo "⚠️ Warning: $stack_directory doesn't have .enc.env file. Skipping..."
            return 0
        fi

        sops decrypt "$stack_directory/.enc.env" >"$stack_directory/.env"
    }

    if [ -n "{{stack}}" ]; then
        stack_directory="$STACKS_DIRECTORY/{{stack}}"

        if [ -d "$stack_directory" ]; then
            decrypt_stack_env "$stack_directory"
        else
            echo "⛔️ Error: $stack_directory doesn't exist. Aborting..."
            exit 1
        fi
    else
        for stack_directory in "$STACKS_DIRECTORY"/*; do
            decrypt_stack_env "$stack_directory"
        done
    fi

    echo "🔓 Decrypted successfully!"

encrypt stack='':
    #!/bin/bash
    set -euo pipefail

    STACKS_DIRECTORY="{{STACKS_DIRECTORY}}"

    encrypt_stack_env() {
        local stack_directory="$1"

        if [ ! -f "$stack_directory/.env" ]; then
            echo "⚠️ Warning: $stack_directory doesn't have .env file. Skipping..."
            return 0
        fi

        sops encrypt "$stack_directory/.env" >"$stack_directory/.enc.env"
    }

    if [ -n "{{stack}}" ]; then
        stack_directory="$STACKS_DIRECTORY/{{stack}}"

        if [ -d "$stack_directory" ]; then
            encrypt_stack_env "$stack_directory"
        else
            echo "⛔️ Error: $stack_directory doesn't exist. Aborting..."
            exit 1
        fi
    else
        for stack_directory in "$STACKS_DIRECTORY"/*; do
            encrypt_stack_env "$stack_directory"
        done
    fi

    echo "🔒 Encrypted successfully!"
