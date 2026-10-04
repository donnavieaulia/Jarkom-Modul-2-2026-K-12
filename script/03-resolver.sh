#!/bin/bash
# Jalankan di SETIAP node non-router setelah prab dan tedd siap.
set -euo pipefail
source "$(dirname -- "$0")/common.sh"
require_node alpha beta gamma delta epsilon prab tedd abbey penny obladi desmond oblada molly
resolver_final
# Pengganti resolver awal sesudah interface aktif, tanpa menumpuk hook.
mkdir -p /etc/network/if-up.d
cat > /etc/network/if-up.d/zz-lab-resolver <<'HOOK'
#!/bin/sh
printf 'nameserver 192.217.1.2\nnameserver 192.217.1.3\nnameserver 192.168.122.1\n' > /etc/resolv.conf
HOOK
chmod +x /etc/network/if-up.d/zz-lab-resolver
cat /etc/resolv.conf
