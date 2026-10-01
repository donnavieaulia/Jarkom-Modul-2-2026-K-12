#!/bin/bash
set -e

apt-get install -y bind9 bind9utils dnsutils >/dev/null

cat > /etc/bind/named.conf.options << 'EOF'
options {
    directory "/var/cache/bind";
    forwarders {
        192.168.122.1;
    };
};
EOF

cat > /etc/bind/named.conf.local << 'EOF'
zone "k12.com" {
    type slave;
    file "/var/cache/bind/db.k12.com";
    masters { 192.217.1.2; };
};
EOF

mkdir -p /run/named
chown bind:bind /run/named
chown -R bind:bind /var/cache/bind
rm -f /var/cache/bind/db.k12.com

named-checkconf

pkill named 2>/dev/null || true
sleep 1
named -u bind -c /etc/bind/named.conf

echo "nameserver 127.0.0.1" > /etc/resolv.conf
echo "[tedd] setup done"