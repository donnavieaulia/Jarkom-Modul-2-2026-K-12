#!/bin/bash
set -e

cat > /etc/bind/db.k12.com << 'EOF'
$TTL    604800
@       IN      SOA     prab.k12.com. admin.k12.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL

@       IN      NS      prab.k12.com.
@       IN      NS      tedd.k12.com.

prab    IN      A       192.217.1.2
tedd    IN      A       192.217.1.3

@       IN      A       192.217.3.2

alpha    IN      A       192.217.4.2
beta     IN      A       192.217.4.3
gamma    IN      A       192.217.4.4
delta    IN      A       192.217.5.2
epsilon  IN      A       192.217.5.3
abbey    IN      A       192.217.2.2
penny    IN      A       192.217.3.2
obladi   IN      A       192.217.1.4
desmond  IN      A       192.217.1.5
oblada   IN      A       192.217.1.6
molly    IN      A       192.217.1.7
EOF

chown bind:bind /etc/bind/db.k12.com
named-checkzone k12.com /etc/bind/db.k12.com
rndc reload k12.com

echo "[prab] soal 5 zona updated, serial=2"