mod env "stacks.env.just"

STACKS_DIRECTORY := "stacks"

alias st := start
alias sp := stop

@logs stack="":
    cd "{{STACKS_DIRECTORY}}/{{stack}}" && docker compose logs -f

@start stack="":
    just stacks _process start "{{stack}}"

@stop stack="":
    just stacks _process stop "{{stack}}"

_process action stack="":
    #!/bin/bash
    set -euo pipefail

    if [ "{{action}}" = "start" ]; then
        compose_command="up -d"
        tailscale_command="--bg --https=8090 http://localhost:8090"
    else
        compose_command="down"
        tailscale_command="--bg --https=8090 off"
    fi

    process() {
        local stack_directory="$1"

        (cd "$stack_directory" && docker compose $compose_command)

        case "$stack_directory" in
        *beszel)
            tailscale serve $tailscale_command
            ;;
        esac

        just _success "$stack_directory"
    }

    if [ -n "{{stack}}" ]; then
        stack_directory="{{STACKS_DIRECTORY}}/{{stack}}"

        if [ -d "$stack_directory" ]; then
            process "$stack_directory"
        else
            just _error "$stack_directory" "Doesn't exist. Aborting..."
            exit 1
        fi
    else
        for stack_directory in "{{STACKS_DIRECTORY}}"/*; do
            process "$stack_directory"
        done
    fi

    just _info "{{action}}ed successfully"
