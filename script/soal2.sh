
# ==== ROOTKIT ====
# Meminta IP dari NAT1 (Internet/WAN) dan memasang IP Forwarding + NAT Masquerade
cat <<'EOF' > /root/soal2.sh
#!/bin/sh
sysctl -w net.ipv4.ip_forward=1

# Minta IP otomatis untuk eth0 (WAN)
dhclient eth0 2>/dev/null &

# Clear aturan iptables lama & pasang MASQUERADE
iptables -t nat -F
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
EOF
chmod +x /root/soal2.sh && /root/soal2.sh


# ==== ALPHA ====
cat <<'EOF' > /root/soal2.sh
#!/bin/sh
# Memastikan default gateway mengarah ke router rootkit
ip route add default via 192.217.1.1 2>/dev/null
EOF
chmod +x /root/soal2.sh && /root/soal2.sh


# ==== BETA ====
cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.1.1 2>/dev/null
EOF
chmod +x /root/soal2.sh && /root/soal2.sh


# ==== GAMMA ====
cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.1.1 2>/dev/null
EOF
chmod +x /root/soal2.sh && /root/soal2.sh


# ==== DELTA ====
cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.2.1 2>/dev/null
EOF
chmod +x /root/soal2.sh && /root/soal2.sh


# ==== EPSILON ====
cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.2.1 2>/dev/null
EOF
chmod +x /root/soal2.sh && /root/soal2.sh


# ==== ABBEY ====
cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.3.1 2>/dev/null
EOF
chmod +x /root/soal2.sh && /root/soal2.sh


# ==== PENNY ====
cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.4.1 2>/dev/null
EOF
chmod +x /root/soal2.sh && /root/soal2.sh


# ==== PRAB ====
cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.5.1 2>/dev/null
EOF
chmod +x /root/soal2.sh && /root/soal2.sh


# ==== TEDD ====
cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.5.1 2>/dev/null
EOF
chmod +x /root/soal2.sh && /root/soal2.sh


# ==== OBLADI ====
cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.5.1 2>/dev/null
EOF
chmod +x /root/soal2.sh && /root/soal2.sh


# ==== DESMOND ====
cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.5.1 2>/dev/null
EOF
chmod +x /root/soal2.sh && /root/soal2.sh


# ==== OBLADA ====
cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.5.1 2>/dev/null
EOF
chmod +x /root/soal2.sh && /root/soal2.sh


# ==== MOLLY ====
cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.5.1 2>/dev/null
EOF
chmod +x /root/soal2.sh && /root/soal2.sh

Pengujian no 2
ping -c 3 google.com
# atau
ping -c 3 192.168.122.1
