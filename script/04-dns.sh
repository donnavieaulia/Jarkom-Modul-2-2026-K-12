#!/bin/bash
# Perbaikan lengkap nomor 4-8. Jalankan prab dahulu, lalu tedd.
set -euo pipefail
source "$(dirname -- "$0")/common.sh"
require_node prab tedd
install_pkgs bind9 bind9-utils dnsutils python3 procps
backup_paths /etc/bind
node=$(hostname -s)
cat > /etc/bind/named.conf.options <<'OPTIONS'
acl lab { 127.0.0.1; 192.217.0.0/16; };
options {
    directory "/var/cache/bind";
    listen-on { any; };
    listen-on-v6 { none; };
    allow-query { lab; };
    recursion yes;
    allow-recursion { lab; };
    forwarders { 192.168.122.1; };
    forward only;
    dnssec-validation no;
};
OPTIONS

if [[ "$node" == prab ]]; then
    # Gunakan serial lebih besar daripada serial pada file lama.
    serial=$(python3 - <<'PY'
import datetime, pathlib, re
serials = [int(datetime.datetime.now().strftime('%Y%m%d') + '00')]
for p in pathlib.Path('/etc/bind').glob('db.*'):
    m = re.search(r'\bSOA\s+\S+\s+\S+\s*\(\s*(\d+)', p.read_text(errors='ignore'))
    if m:
        serials.append(int(m[1]) + 1)
value = max(serials)
if value > 4294967295:
    raise SystemExit('Serial melebihi batas uint32; periksa serial zona lama.')
print(value)
PY
)
    cat > /etc/bind/named.conf.local <<'MASTER'
zone "k12.com" {
    type master;
    file "/etc/bind/db.k12.com";
    notify yes;
    also-notify { 192.217.1.3; };
    allow-transfer { 192.217.1.3; };
};
MASTER
    cat > /etc/bind/db.k12.com <<ZONE
\$TTL 300
@ IN SOA prab.k12.com. admin.k12.com. (
    $serial ; Serial
    60 ; Refresh
    30 ; Retry
    604800 ; Expire
    30 ) ; Negative Cache TTL
@ IN NS prab.k12.com.
@ IN NS tedd.k12.com.
@ IN A 192.217.3.2
rootkit IN A 192.217.1.1
prab IN A 192.217.1.2
tedd IN A 192.217.1.3
obladi IN A 192.217.1.4
desmond IN A 192.217.1.5
oblada IN A 192.217.1.6
molly IN A 192.217.1.7
abbey IN A 192.217.2.2
penny IN A 192.217.3.2
alpha IN A 192.217.4.2
beta IN A 192.217.4.3
gamma IN A 192.217.4.4
delta IN A 192.217.5.2
epsilon IN A 192.217.5.3
vault IN A 192.217.1.4
vault IN A 192.217.1.5
core IN A 192.217.1.6
core IN A 192.217.1.7
www IN CNAME penny.k12.com.
static IN CNAME abbey.k12.com.
ZONE
    for seg in 1 2 3; do
        cat >> /etc/bind/named.conf.local <<ZONE
zone "$seg.217.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.217.$seg";
    notify yes;
    also-notify { 192.217.1.3; };
    allow-transfer { 192.217.1.3; };
};
ZONE
        cat > "/etc/bind/db.192.217.$seg" <<ZONE
\$TTL 300
@ IN SOA prab.k12.com. admin.k12.com. (
    $serial ; Serial
    60 ; Refresh
    30 ; Retry
    604800 ; Expire
    30 ) ; Negative Cache TTL
@ IN NS prab.k12.com.
@ IN NS tedd.k12.com.
ZONE
    done
    cat >> /etc/bind/db.192.217.1 <<'PTR'
1 IN PTR rootkit.k12.com.
2 IN PTR prab.k12.com.
3 IN PTR tedd.k12.com.
4 IN PTR obladi.k12.com.
5 IN PTR desmond.k12.com.
6 IN PTR oblada.k12.com.
7 IN PTR molly.k12.com.
PTR
    printf '2 IN PTR abbey.k12.com.\n' >> /etc/bind/db.192.217.2
    printf '2 IN PTR penny.k12.com.\n' >> /etc/bind/db.192.217.3
    named-checkzone k12.com /etc/bind/db.k12.com
    for seg in 1 2 3; do named-checkzone "$seg.217.192.in-addr.arpa" "/etc/bind/db.192.217.$seg"; done
else
    cat > /etc/bind/named.conf.local <<'SLAVE'
zone "k12.com" {
    type slave;
    file "/var/cache/bind/db.k12.com";
    masters { 192.217.1.2; };
    allow-notify { 192.217.1.2; };
    allow-transfer { none; };
};
SLAVE
    for seg in 1 2 3; do
        cat >> /etc/bind/named.conf.local <<ZONE
zone "$seg.217.192.in-addr.arpa" {
    type slave;
    file "/var/cache/bind/db.192.217.$seg";
    masters { 192.217.1.2; };
    allow-notify { 192.217.1.2; };
    allow-transfer { none; };
};
ZONE
    done
fi
chmod 644 /etc/bind/db.k12.com 2>/dev/null || true
named_up
if [[ "$node" == tedd ]]; then
    for zone in k12.com 1.217.192.in-addr.arpa 2.217.192.in-addr.arpa 3.217.192.in-addr.arpa; do
        rndc retransfer "$zone"
    done
fi
echo "DNS $node sudah dikonfigurasi; verifikasi SOA dan flag aa dari klien."
