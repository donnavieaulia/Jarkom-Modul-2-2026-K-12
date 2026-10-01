# =========================================================
# ==== ROOTKIT ====
# =========================================================

cat <<'EOF' > /root/soal2.sh
#!/bin/sh

# Enable IP Forwarding
sysctl -w net.ipv4.ip_forward=1

# Minta IP otomatis untuk eth0 (WAN)
dhclient eth0 2>/dev/null &

# Clear aturan NAT lama
iptables -t nat -F

# NAT Masquerade keluar melalui eth0
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
EOF

chmod +x /root/soal2.sh
/root/soal2.sh


# =========================================================
# ==== ALPHA ====
# Gateway: 192.217.4.1
# =========================================================

cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.4.1 2>/dev/null
EOF

chmod +x /root/soal2.sh
/root/soal2.sh


# =========================================================
# ==== BETA ====
# Gateway: 192.217.4.1
# =========================================================

cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.4.1 2>/dev/null
EOF

chmod +x /root/soal2.sh
/root/soal2.sh


# =========================================================
# ==== GAMMA ====
# Gateway: 192.217.4.1
# =========================================================

cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.4.1 2>/dev/null
EOF

chmod +x /root/soal2.sh
/root/soal2.sh


# =========================================================
# ==== DELTA ====
# Gateway: 192.217.5.1
# =========================================================

cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.5.1 2>/dev/null
EOF

chmod +x /root/soal2.sh
/root/soal2.sh


# =========================================================
# ==== EPSILON ====
# Gateway: 192.217.5.1
# =========================================================

cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.5.1 2>/dev/null
EOF

chmod +x /root/soal2.sh
/root/soal2.sh


# =========================================================
# ==== ABBEY ====
# Gateway: 192.217.2.1
# =========================================================

cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.2.1 2>/dev/null
EOF

chmod +x /root/soal2.sh
/root/soal2.sh


# =========================================================
# ==== PENNY ====
# Gateway: 192.217.3.1
# =========================================================

cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.3.1 2>/dev/null
EOF

chmod +x /root/soal2.sh
/root/soal2.sh


# =========================================================
# ==== PRAB ====
# Gateway: 192.217.1.1
# =========================================================

cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.1.1 2>/dev/null
EOF

chmod +x /root/soal2.sh
/root/soal2.sh


# =========================================================
# ==== TEDD ====
# Gateway: 192.217.1.1
# =========================================================

cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.1.1 2>/dev/null
EOF

chmod +x /root/soal2.sh
/root/soal2.sh


# =========================================================
# ==== OBLADI ====
# Gateway: 192.217.1.1
# =========================================================

cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.1.1 2>/dev/null
EOF

chmod +x /root/soal2.sh
/root/soal2.sh


# =========================================================
# ==== DESMOND ====
# Gateway: 192.217.1.1
# =========================================================

cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.1.1 2>/dev/null
EOF

chmod +x /root/soal2.sh
/root/soal2.sh


# =========================================================
# ==== OBLADA ====
# Gateway: 192.217.1.1
# =========================================================

cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.1.1 2>/dev/null
EOF

chmod +x /root/soal2.sh
/root/soal2.sh


# =========================================================
# ==== MOLLY ====
# Gateway: 192.217.1.1
# =========================================================

cat <<'EOF' > /root/soal2.sh
#!/bin/sh
ip route add default via 192.217.1.1 2>/dev/null
EOF

chmod +x /root/soal2.sh
/root/soal2.sh
