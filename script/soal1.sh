
# ==== ROOTKIT ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 192.217.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 192.217.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 192.217.3.1
    netmask 255.255.255.0

auto eth4
iface eth4 inet static
    address 192.217.4.1
    netmask 255.255.255.0

auto eth5
iface eth5 inet static
    address 192.217.5.1
    netmask 255.255.255.0
EOF

# ==== ALPHA ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.217.1.2
    netmask 255.255.255.0
    gateway 192.217.1.1
EOF

# ==== BETA ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.217.1.3
    netmask 255.255.255.0
    gateway 192.217.1.1
EOF

# ==== GAMMA ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.217.1.4
    netmask 255.255.255.0
    gateway 192.217.1.1
EOF

# ==== DELTA ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.217.2.2
    netmask 255.255.255.0
    gateway 192.217.2.1
EOF

# ==== EPSILON ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.217.2.3
    netmask 255.255.255.0
    gateway 192.217.2.1
EOF

# ==== ABBEY ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.217.3.2
    netmask 255.255.255.0
    gateway 192.217.3.1
EOF

# ==== PENNY ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.217.4.2
    netmask 255.255.255.0
    gateway 192.217.4.1
EOF

# ==== PRAB ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.217.5.2
    netmask 255.255.255.0
    gateway 192.217.5.1
EOF

# ==== TEDD ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.217.5.3
    netmask 255.255.255.0
    gateway 192.217.5.1
EOF

# ==== OBLADI ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.217.5.4
    netmask 255.255.255.0
    gateway 192.217.5.1
EOF

# ==== DESMOND ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.217.5.5
    netmask 255.255.255.0
    gateway 192.217.5.1
EOF

# ==== OBLADA ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.217.5.6
    netmask 255.255.255.0
    gateway 192.217.5.1
EOF

# ==== MOLLY ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.217.5.7
    netmask 255.255.255.0
    gateway 192.217.5.1
EOF
