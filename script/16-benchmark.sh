#!/bin/bash
# Nomor 16 - ApacheBench 250 request, concurrency 10. Jalankan di ALPHA.
set -euo pipefail
source "$(dirname -- "$0")/common.sh"
require_node alpha
install_pkgs apache2-utils curl
mkdir -p /root/bukti-demo
for host in www.k12.com static.k12.com; do
    status=$(curl --noproxy '*' --max-time 10 -sS -o /dev/null -w '%{http_code}' "http://$host/")
    printf '%s: HTTP %s\n' "$host" "$status"
    if [ "$status" != 200 ]; then
        echo 'Berhenti: perbaiki endpoint sebelum benchmark.'
        exit 1
    fi
done
ab -l -n 250 -c 10 http://www.k12.com/    2>&1 | tee /root/bukti-demo/16-ab-www.txt
ab -l -n 250 -c 10 http://static.k12.com/ 2>&1 | tee /root/bukti-demo/16-ab-static.txt
for layanan in www static; do
    printf '\nRINGKASAN %s\n' "$layanan"
    grep -E '^(Concurrency Level|Time taken for tests|Complete requests|Failed requests|Non-2xx responses|Requests per second|Time per request|Transfer rate):' "/root/bukti-demo/16-ab-$layanan.txt"
done
