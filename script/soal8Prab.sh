#!/bin/bash
set -e

cat >> /etc/bind/named.conf.local << 'EOF'

zone "2.217.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.217.2";
    allow-transfer { 192.217.5.3; };
};

zone "3.217.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.217.4";
    allow-transfer { 192.217.5.3; };
};

zone "1.217.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.217.5";
    allow-transfer { 192.217.5.3; };
};
EOF

cat > /etc/bind/db.192.217.2 << 'EOF'
$TTL    604800
@       IN      SOA     prab.k12.com. admin.k12.com. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL

@       IN      NS      prab.k12.com.
@       IN      NS      tedd.k12.com.

2       IN      PTR     abbey.k12.com.
EOF

cat > /etc/bind/db.192.217.3 << 'EOF'
$TTL    604800
@       IN      SOA     prab.k12.com. admin.k12.com. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL

@       IN      NS      prab.k12.com.
@       IN      NS      tedd.k12.com.

2       IN      PTR     penny.k12.com.
EOF

cat > /etc/bind/db.192.217.1 << 'EOF'
$TTL    604800
@       IN      SOA     prab.k12.com. admin.k12.com. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL

@       IN      NS      prab.k12.com.
@       IN      NS      tedd.k12.com.

2       IN      PTR     prab.k12.com.
3       IN      PTR     tedd.k12.com.
4       IN      PTR     obladi.k12.com.
5       IN      PTR     desmond.k12.com.
6       IN      PTR     oblada.k12.com.
7       IN      PTR     molly.k12.com.
EOF

chown bind:bind /etc/bind/db.192.217.2 /etc/bind/db.192.217.3 /etc/bind/db.192.217.1

named-checkconf
named-checkzone 2.217.192.in-addr.arpa /etc/bind/db.192.217.2
named-checkzone 3.217.192.in-addr.arpa /etc/bind/db.192.217.3
named-checkzone 1.217.192.in-addr.arpa /etc/bind/db.192.217.1

rndc reload

echo "[prab] soal 8 reverse zones added"