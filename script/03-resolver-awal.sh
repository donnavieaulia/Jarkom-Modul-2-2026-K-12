#!/bin/bash
# Nomor 3 - resolver awal (SEBELUM DNS internal aktif). Jalankan di SETIAP node non-router.
set -euo pipefail
printf 'nameserver 192.168.122.1\n' > /etc/resolv.conf
bash -c 'source /root/common.sh; install_pkgs curl dnsutils iputils-ping'
