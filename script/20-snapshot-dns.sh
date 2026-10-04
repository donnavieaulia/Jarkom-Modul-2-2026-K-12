#!/bin/bash
# Nomor 20 - perbarui snapshot konfigurasi di PRAB lalu TEDD
# (setelah demo nomor 17-19, sebelum Stop/Start node).
set -euo pipefail
case "$(hostname -s)" in
    prab|tedd) ;;
    *) echo 'Jalankan hanya pada Prab atau Tedd.'; exit 1 ;;
esac
snapshot=/root/lab-state/config.tar.gz
test -f "$snapshot" || { echo 'Snapshot tidak ditemukan. Jalankan 20-autostart.sh dahulu.'; exit 1; }
primary_serial=$(dig @192.217.1.2 k12.com SOA +short | awk 'NR == 1 {print $3}')
secondary_serial=$(dig @192.217.1.3 k12.com SOA +short | awk 'NR == 1 {print $3}')
test -n "$primary_serial" && test "$primary_serial" = "$secondary_serial" || {
    echo 'Serial belum sama. Tunggu sinkronisasi sebelum memperbarui snapshot.'; exit 1;
}
for dns in 192.217.1.2 192.217.1.3; do
    test "$(dig @"$dns" abbey.k12.com A +short)" = 192.217.2.2 || {
        echo 'IP Abbey belum normal pada kedua DNS.'; exit 1;
    }
done
paths=()
for path in etc/hostname etc/hosts etc/network/interfaces etc/network/if-up.d/zz-lab-resolver \
    etc/sysctl.d/99-lab-router.conf etc/bind etc/apache2 etc/nginx etc/php \
    var/www arsip var/cache/bind; do
    [ ! -e "/$path" ] || paths+=("$path")
done
tar -C / -czf "$snapshot.new" "${paths[@]}"
mv "$snapshot.new" "$snapshot"
echo "Snapshot $(hostname -s) diperbarui pada serial $primary_serial."
