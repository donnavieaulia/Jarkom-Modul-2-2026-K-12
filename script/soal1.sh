# === ROOTKIT ===
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

# Terhubung ke NAT1
auto eth0
iface eth0 inet dhcp

# Terhubung ke Switch1 (Zone Server: prab, tedd, obladi, desmond, oblada, molly)
auto eth1
iface eth1 inet static
    address 10.12.5.1
    netmask 255.255.255.0

# Terhubung ke Switch4 (abbey)
auto eth2
iface eth2 inet static
    address 10.12.3.1
    netmask 255.255.255.0

# Terhubung ke Switch5 (penny)
auto eth3
iface eth3 inet static
    address 10.12.4.1
    netmask 255.255.255.0

# Terhubung ke Switch6 (Sayap Kiri: alpha, beta, gamma)
auto eth4
iface eth4 inet static
    address 10.12.1.1
    netmask 255.255.255.0

# Terhubung ke Switch7 (Sayap Kanan: delta, epsilon)
auto eth5
iface eth5 inet static
    address 10.12.2.1
    netmask 255.255.255.0
EOF

# Enable IP Forwarding di Rootkit
sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf


# === ALPHA ===
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.12.1.2
    netmask 255.255.255.0
    gateway 10.12.1.1
EOF


# === BETA ===
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.12.1.3
    netmask 255.255.255.0
    gateway 10.12.1.1
EOF


# === GAMMA ===
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.12.1.4
    netmask 255.255.255.0
    gateway 10.12.1.1
EOF


# === DELTA ===
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.12.2.2
    netmask 255.255.255.0
    gateway 10.12.2.1
EOF


# === EPSILON ===
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.12.2.3
    netmask 255.255.255.0
    gateway 10.12.2.1
EOF


# === ABBEY ===
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.12.3.2
    netmask 255.255.255.0
    gateway 10.12.3.1
EOF


# === PENNY ===
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.12.4.2
    netmask 255.255.255.0
    gateway 10.12.4.1
EOF


# === PRAB ===
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.12.5.2
    netmask 255.255.255.0
    gateway 10.12.5.1
EOF


# === TEDD ===
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.12.5.3
    netmask 255.255.255.0
    gateway 10.12.5.1
EOF


# === OBLADI ===
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.12.5.4
    netmask 255.255.255.0
    gateway 10.12.5.1
EOF


# === DESMOND ===
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.12.5.5
    netmask 255.255.255.0
    gateway 10.12.5.1
EOF


# === OBLADA ===
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.12.5.6
    netmask 255.255.255.0
    gateway 10.12.5.1
EOF


# === MOLLY ===
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.12.5.7
    netmask 255.255.255.0
    gateway 10.12.5.1
EOF
