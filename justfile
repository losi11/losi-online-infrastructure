decrypt-stacks-env:
    ./scripts/stacks/decrypt-env.sh

encrypt-stacks-env:
    ./scripts/stacks/encrypt-env.sh

start-stacks:
    ./scripts/stacks/start.sh

stop-stacks:
    ./scripts/stacks/stop.sh

maintain:
    ./scripts/maintain.sh

alias dse := decrypt-stacks-env
alias ese := encrypt-stacks-env
alias ss := start-stacks
alias sp := stop-stacks
alias m := maintain
