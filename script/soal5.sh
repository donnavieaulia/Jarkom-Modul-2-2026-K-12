cat << 'EOF' > /root/soal5_prab.sh
#!/bin/bash

# 1. Set Hostname System-wide
hostnamectl set-hostname prab 2>/dev/null || echo "prab" > /etc/hostname && hostname -F /etc/hostname

# 2. Lokasi File Zone
ZONE_FILE=""
if [ -f /etc/bind/jarkom/k12.com ]; then
    ZONE_FILE="/etc/bind/jarkom/k12.com"
else
    ZONE_FILE="/etc/bind/k12.com"
fi

# 3. Update File Zone dengan Subdomain (Soal 5)
cat << 'ZONE' > $ZONE_FILE
$TTL    604800
@       IN      SOA     prab.k12.com. root.k12.com. (
                              2026093002 ; Serial
                                  604800 ; Refresh
                                   86400 ; Retry
                                 2419200 ; Expire
                                  604800 ) ; Negative Cache TTL
;
@       IN      NS      prab.k12.com.
@       IN      NS      tedd.k12.com.

; Apex & Direct Node
@       IN      A       192.217.3.3
prab    IN      A       192.217.5.2
tedd    IN      A       192.217.5.3

; Subdomain Nodes (Soal 5)
alpha   IN      A       192.217.1.2
beta    IN      A       192.217.1.3
gamma   IN      A       192.217.1.4
delta   IN      A       192.217.2.2
epsilon IN      A       192.217.2.3
abbey   IN      A       192.217.3.2
penny   IN      A       192.217.3.3
obladi  IN      A       192.217.5.4
desmond IN      A       192.217.5.5
oblada  IN      A       192.217.5.6
molly   IN      A       192.217.5.7
ZONE

# 4. Restart BIND9
pkill named && named || named

# 5. Pengujian Soal 5 di Master
echo "=== HASIL PENGUJIAN SOAL 5 (prab) ==="
host alpha.k12.com 127.0.0.1
host abbey.k12.com 127.0.0.1
host obladi.k12.com 127.0.0.1
EOF

chmod +x /root/soal5_prab.sh
bash /root/soal5_prab.sh

# Konfigurasi Hostname System-Wide & Record Subdomain Domain

cat << 'EOF' > /root/soal5_prab.sh
#!/bin/bash

# 1. Set Hostname System-wide
hostnamectl set-hostname prab 2>/dev/null || echo "prab" > /etc/hostname && hostname -F /etc/hostname

# 2. Lokasi File Zone
ZONE_FILE=""
if [ -f /etc/bind/jarkom/k12.com ]; then
    ZONE_FILE="/etc/bind/jarkom/k12.com"
else
    ZONE_FILE="/etc/bind/k12.com"
fi

# 3. Update File Zone dengan Subdomain (Soal 5)
cat << 'ZONE' > $ZONE_FILE
$TTL    604800
@       IN      SOA     prab.k12.com. root.k12.com. (
                              2026093002 ; Serial
                                  604800 ; Refresh
                                   86400 ; Retry
                                 2419200 ; Expire
                                  604800 ) ; Negative Cache TTL
;
@       IN      NS      prab.k12.com.
@       IN      NS      tedd.k12.com.

; Apex & Direct Node
@       IN      A       192.217.3.3
prab    IN      A       192.217.5.2
tedd    IN      A       192.217.5.3

; Subdomain Nodes (Soal 5)
alpha   IN      A       192.217.1.2
beta    IN      A       192.217.1.3
gamma   IN      A       192.217.1.4
delta   IN      A       192.217.2.2
epsilon IN      A       192.217.2.3
abbey   IN      A       192.217.3.2
penny   IN      A       192.217.3.3
obladi  IN      A       192.217.5.4
desmond IN      A       192.217.5.5
oblada  IN      A       192.217.5.6
molly   IN      A       192.217.5.7
ZONE

# 4. Restart BIND9
pkill named && named || named

# 5. Pengujian Soal 5 di Master
echo "=== HASIL PENGUJIAN SOAL 5 (prab) ==="
host alpha.k12.com 127.0.0.1
host abbey.k12.com 127.0.0.1
host obladi.k12.com 127.0.0.1
EOF

chmod +x /root/soal5_prab.sh
bash /root/soal5_prab.sh

#perintah set hostname node lain

# Di node alpha:
hostnamectl set-hostname alpha 2>/dev/null || echo "alpha" > /etc/hostname && hostname -F /etc/hostname

# Di node beta:
hostnamectl set-hostname beta 2>/dev/null || echo "beta" > /etc/hostname && hostname -F /etc/hostname

# Di node gamma:
hostnamectl set-hostname gamma 2>/dev/null || echo "gamma" > /etc/hostname && hostname -F /etc/hostname

# Di node delta:
hostnamectl set-hostname delta 2>/dev/null || echo "delta" > /etc/hostname && hostname -F /etc/hostname

# Di node epsilon:
hostnamectl set-hostname epsilon 2>/dev/null || echo "epsilon" > /etc/hostname && hostname -F /etc/hostname

# Di node abbey:
hostnamectl set-hostname abbey 2>/dev/null || echo "abbey" > /etc/hostname && hostname -F /etc/hostname

# Di node penny:
hostnamectl set-hostname penny 2>/dev/null || echo "penny" > /etc/hostname && hostname -F /etc/hostname

# Di node obladi:
hostnamectl set-hostname obladi 2>/dev/null || echo "obladi" > /etc/hostname && hostname -F /etc/hostname

# Di node desmond:
hostnamectl set-hostname desmond 2>/dev/null || echo "desmond" > /etc/hostname && hostname -F /etc/hostname

# Di node oblada:
hostnamectl set-hostname oblada 2>/dev/null || echo "oblada" > /etc/hostname && hostname -F /etc/hostname

# Di node molly:
hostnamectl set-hostname molly 2>/dev/null || echo "molly" > /etc/hostname && hostname -F /etc/hostname
