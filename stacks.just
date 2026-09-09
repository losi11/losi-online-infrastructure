mod env 'stacks.env.just'

STACKS_DIRECTORY := "stacks"

start stack='':
    #!/bin/bash
    set -euo pipefail

    STACKS_DIRECTORY="{{STACKS_DIRECTORY}}"

    start_stack() {
        local stack_directory="$1"

        (cd "$stack_directory" && docker compose up -d)

        case "$stack_directory" in
        *beszel)
            sudo tailscale serve --bg --https=8090 http://localhost:8090
            ;;
        esac
    }

    if [ -n "{{stack}}" ]; then
        stack_directory="$STACKS_DIRECTORY/{{stack}}"

        if [ -d "$stack_directory" ]; then
            start_stack "$stack_directory"
        else
            echo "⛔️ Error: $stack_directory doesn't exist. Aborting..."
            exit 1
        fi
    else
        for stack_directory in "$STACKS_DIRECTORY"/*; do
            start_stack "$stack_directory"
        done
    fi

    echo "✅ Started successfully!"

stop stack='':
    #!/bin/bash
    set -euo pipefail

    STACKS_DIRECTORY="{{STACKS_DIRECTORY}}"

    stop_stack() {
        local stack_directory="$1"

        (cd "$stack_directory" && docker compose down)

        case "$stack_directory" in
        *beszel)
            sudo tailscale serve --bg --https=8090 off
            ;;
        esac
    }

    if [ -n "{{stack}}" ]; then
        stack_directory="$STACKS_DIRECTORY/{{stack}}"

        if [ -d "$stack_directory" ]; then
            stop_stack "$stack_directory"
        else
            echo "⛔️ Error: $stack_directory doesn't exist. Aborting..."
            exit 1
        fi
    else
        for stack_directory in "$STACKS_DIRECTORY"/*; do
            stop_stack "$stack_directory"
        done
    fi

    echo "🚫 Stopped successfully!"
