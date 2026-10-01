#!/bin/bash
set -e

cat >> /etc/bind/named.conf.local << 'EOF'

zone "2.217.192.in-addr.arpa" {
    type slave;
    file "/var/cache/bind/db.192.217.2";
    masters { 192.217.1.2; };
};

zone "3.217.192.in-addr.arpa" {
    type slave;
    file "/var/cache/bind/db.192.217.3";
    masters { 192.217.1.2; };
};

zone "1.217.192.in-addr.arpa" {
    type slave;
    file "/var/cache/bind/db.192.217.1";
    masters { 192.217.1.2; };
};
EOF

named-checkconf
rndc reload

echo "[tedd] soal 8 reverse zones added as slave"