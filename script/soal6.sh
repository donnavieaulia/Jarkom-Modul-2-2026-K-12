cat << 'EOF' > /root/soal6_tedd.sh
#!/bin/bash

# 1. Set Hostname System-wide untuk tedd
hostnamectl set-hostname tedd 2>/dev/null || echo "tedd" > /etc/hostname && hostname -F /etc/hostname

# 2. Hapus Cache Zone Slave Lama & Paksa Re-sync dari Master
rm -f /var/cache/bind/k12.com /var/lib/bind/k12.com /etc/bind/k12.com 2>/dev/null

# 3. Restart Service BIND9 di Slave
pkill named && named || named

# Jeda 2 detik agar proses zone transfer selesai
sleep 2

# 4. Verifikasi Sinkronisasi Zone Transfer (Soal 6)
echo "=== HASIL PENGUJIAN SOAL 6 (tedd) ==="
echo "- Memeriksa Serial SOA di Slave (Harus 2026093002):"
host -t SOA k12.com 127.0.0.1

echo "- Memeriksa Resolve Subdomain dari Slave:"
host alpha.k12.com 127.0.0.1
host oblada.k12.com 127.0.0.1
EOF

chmod +x /root/soal6_tedd.sh
bash /root/soal6_tedd.sh
