#!/bin/bash
# HANYA alpha. Resolver cache sementara pada 127.0.0.1:5300.
set -euo pipefail
source "$(dirname -- "$0")/common.sh"
require_node alpha
action=${1:-setup}
case "$action" in
setup)
    install_pkgs dnsmasq-base dnsutils
    cat > /root/cache18.conf <<'CACHE'
port=5300
listen-address=127.0.0.1
bind-interfaces
no-resolv
no-hosts
cache-size=100
server=/k12.com/192.217.1.2
pid-file=/run/cache18.pid
log-facility=/root/cache18.log
CACHE
    ;;
reset)
    [[ -f /root/cache18.conf ]] || { echo 'Jalankan setup terlebih dahulu.' >&2; exit 1; }
    if [[ -f /run/cache18.pid ]] && kill -0 "$(cat /run/cache18.pid)" 2>/dev/null; then
        # HUP mengosongkan cache dnsmasq. JANGAN lakukan di tengah pengamatan.
        kill -HUP "$(cat /run/cache18.pid)"
    else
        dnsmasq --test --conf-file=/root/cache18.conf
        dnsmasq --conf-file=/root/cache18.conf
    fi
    sleep 1
    ;;
watch)
    mkdir -p /root/bukti
    echo 'Jalankan aksi fake pada PRAB sekitar detik ke-3. Jangan reset cache selama pengamatan.'
    {
        for ((i=0; i<30; i++)); do
            date '+Waktu %H:%M:%S'
            echo 'CACHE ALPHA (TTL harus menurun):'
            dig @127.0.0.1 -p 5300 abbey.k12.com A +noall +answer +time=1 +tries=1
            echo 'AUTHORITATIVE PRAB:'
            dig @192.217.1.2 abbey.k12.com A +noall +answer +time=1 +tries=1
            sleep 1
        done
    } | tee /root/bukti/ttl-abbey.txt
    ;;
stop)
    if [[ -f /run/cache18.pid ]] && kill -0 "$(cat /run/cache18.pid)" 2>/dev/null; then
        kill "$(cat /run/cache18.pid)"
    fi
    ;;
*) echo 'Gunakan: setup | reset | watch | stop' >&2; exit 1 ;;
esac
