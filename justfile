alias dec := decrypt
alias enc := encrypt

@decrypt:
    sops decrypt .enc.env >.env

@encrypt:
    sops encrypt .env >.enc.env
