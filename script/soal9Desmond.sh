#!/bin/bash
set -e

apt-get install -y apache2 >/dev/null

mkdir -p /arsip
echo "file contoh 1" > /arsip/contoh1.txt
echo "file contoh 2" > /arsip/contoh2.txt

cat > /etc/apache2/sites-available/arsip.conf << 'EOF'
<VirtualHost *:80>
    ServerName desmond.k12.com
    DocumentRoot /var/www/html

    Alias /arsip /arsip

    <Directory /arsip>
        Options +Indexes +FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
EOF

a2dissite 000-default.conf
a2ensite arsip.conf
a2enmod autoindex

apache2ctl configtest
pkill apache2 2>/dev/null || true
sleep 1
apache2ctl start

echo "[desmond] soal 9 done"