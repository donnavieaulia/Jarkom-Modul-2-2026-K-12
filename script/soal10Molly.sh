#!/bin/bash
set -e

apt-get install -y nginx php8.4-fpm >/dev/null

mkdir -p /var/www/core
cat > /var/www/core/index.php << 'EOF'
<?php
echo "<h1>Beranda - molly</h1>";
echo "<p>Selamat datang di area core.</p>";
echo "<p><a href='/profil'>Lihat Profil</a></p>";
EOF

cat > /var/www/core/profil.php << 'EOF'
<?php
echo "<h1>Halaman Profil</h1>";
echo "<p>Ini halaman profil, diakses lewat URL bersih /profil (tanpa .php).</p>";
EOF

cat > /etc/nginx/sites-available/core.conf << 'EOF'
server {
    listen 80;
    server_name molly.k12.com;
    root /var/www/core;
    index index.php;

    location / {
        try_files $uri $uri.php $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF

rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/core.conf /etc/nginx/sites-enabled/core.conf

nginx -t

mkdir -p /run/php
php-fpm8.4 -D
pkill nginx 2>/dev/null || true
sleep 1
nginx

echo "[molly] soal 10 done"