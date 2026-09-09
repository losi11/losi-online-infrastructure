alias mn := maintain

@maintain:
    #!/bin/bash
    set -euo pipefail

    @journalctl --vacuum-time=7d

    @sudo apt autoremove -y --purge
    @sudo apt clean

    @docker system prune -af
    @docker volume prune -f

    just info "maintaned successfully"
