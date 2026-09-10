STACKS_DIRECTORY := "stacks"

alias dt := decrypt
alias et := encrypt

@decrypt stack="":
    just stacks env _process decrypt "{{stack}}"

@encrypt stack="":
    just stacks env _process encrypt "{{stack}}"

_process action stack="":
    #!/bin/bash
    set -euo pipefail

    if [ "{{action}}" = "decrypt" ]; then
        source=".enc.env"
        target=".env"
    else
        source=".env"
        target=".enc.env"
    fi

    process() {
        local stack_directory="$1"

        if [ ! -f "$stack_directory/$source" ]; then
            just _warn "$stack_directory" "Doesn't have $source file. Skipping..."
            return 0
        fi

        sops "{{action}}" "$stack_directory/$source" >"$stack_directory/$target"
        just _success "$stack_directory"
    }

    if [ -n "{{ stack }}" ]; then
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
