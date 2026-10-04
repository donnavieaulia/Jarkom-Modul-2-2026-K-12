#!/bin/bash
# HANYA abbey. Konfigurasi gabungan nomor 11, 13, dan 15.
set -euo pipefail
source "$(dirname -- "$0")/common.sh"
require_node abbey
install_pkgs nginx curl procps
backup_paths /etc/nginx /var/www/orion
mkdir -p /var/www/orion
printf '<h1>Orion statis aktif</h1><p>Disajikan oleh Abbey.</p>\n' > /var/www/orion/index.html
cat > /etc/nginx/sites-available/abbey.conf <<'CONFIG'
upstream core_backend {
    server 192.217.1.6:80;
    server 192.217.1.7:80;
}
server {
    listen 80 default_server;
    server_name _;
    return 302 http://static.k12.com$request_uri;
}
server {
    listen 80;
    server_name static.k12.com;
    access_log /var/log/nginx/abbey-access.log;
    error_log /var/log/nginx/abbey-error.log;

    location = /orion {
        return 302 /orion/$is_args$args;
    }
    location /orion/ {
        alias /var/www/orion/;
        index index.html;
        autoindex on;
        # PHP di jalur ini ditolak, tidak dieksekusi atau dibocorkan.
        location ~* \.php(?:/|$) {
            return 403;
        }
    }
    location / {
        proxy_pass http://core_backend;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
CONFIG
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/abbey.conf /etc/nginx/sites-enabled/abbey.conf
nginx_up
