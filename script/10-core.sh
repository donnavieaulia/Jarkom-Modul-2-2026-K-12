#!/bin/bash
# HANYA oblada dan molly. Perbaiki /profil + log real IP nomor 14.
set -euo pipefail
source "$(dirname -- "$0")/common.sh"
require_node oblada molly
node=$(hostname -s)
install_pkgs nginx php8.4-fpm curl procps
backup_paths /etc/nginx /var/www/core
mkdir -p /var/www/core
if [[ ! -f /var/www/core/index.php ]]; then
    cat > /var/www/core/index.php <<PHP
<?php
echo '<h1>Beranda - $node</h1>';
echo '<p>Selamat datang di area core.</p>';
echo '<p><a href="/profil">Lihat Profil</a></p>';
PHP
fi
if [[ ! -f /var/www/core/profil.php ]]; then
    cat > /var/www/core/profil.php <<'PHP'
<?php
echo '<h1>Halaman Profil</h1>';
echo '<p>Profil diakses melalui URL bersih /profil.</p>';
PHP
fi
cat > /etc/nginx/conf.d/lab-log.conf <<'LOG'
log_format lab_realip 'client=$remote_addr peer=$realip_remote_addr host=$host '
                      '[$time_local] "$request" $status $body_bytes_sent';
LOG
cat > /etc/nginx/sites-available/core.conf <<CONFIG
server {
    listen 80 default_server;
    server_name $node.k12.com core.k12.com static.k12.com abbey.k12.com;
    root /var/www/core;
    index index.php;
    set_real_ip_from 192.217.2.2;
    real_ip_header X-Real-IP;
    access_log /var/log/nginx/core-access.log lab_realip;
    error_log /var/log/nginx/core-error.log;
    add_header X-Backend "$node" always;

    location = /profil {
        rewrite ^ /profil.php last;
    }
    location / {
        try_files \$uri \$uri/ =404;
    }
    location ~ \\.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
CONFIG
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/core.conf /etc/nginx/sites-enabled/core.conf
php_up
nginx_up
