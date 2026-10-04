#!/bin/bash
# HANYA penny. Konfigurasi gabungan nomor 11, 12, 13, dan 15.
set -euo pipefail
source "$(dirname -- "$0")/common.sh"
require_node penny
install_pkgs apache2 apache2-utils php8.4-fpm curl procps
backup_paths /etc/apache2 /var/www/admin /var/www/eternal
mkdir -p /var/www/admin /var/www/eternal
printf '<h1>Admin Penny</h1><p>Autentikasi berhasil.</p>\n' > /var/www/admin/index.html
cat > /var/www/eternal/index.php <<'PHP'
<?php
header('Content-Type: text/html; charset=UTF-8');
echo '<h1>Eternal PHP aktif</h1>';
echo '<p>Hasil perhitungan PHP: ' . (2 + 3) . '</p>';
PHP
# Tiga karakter * berikut adalah literal, sama dengan yang tertulis di PDF.
printf '%s\n' 'pakar_pinter_jadi_gob***' | htpasswd -iBc /etc/apache2/.htpasswd prabs
chown root:www-data /etc/apache2/.htpasswd
chmod 640 /etc/apache2/.htpasswd
a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests headers rewrite \
    auth_basic authn_file authz_user proxy_fcgi remoteip
cat > /etc/apache2/conf-available/eternal-listen.conf <<'LISTEN'
Listen 127.0.0.1:8080
LISTEN
a2enconf eternal-listen
cat > /etc/apache2/sites-available/penny.conf <<'CONFIG'
<VirtualHost *:80>
    ServerName www.k12.com
    ServerAlias penny.k12.com k12.com 192.217.3.2
    ProxyRequests Off
    ProxyPreserveHost On
    RequestHeader set X-Real-IP "expr=%{REMOTE_ADDR}"
    RequestHeader unset X-Forwarded-For

    # Host nonkanonik ke WWW, path dan query string tetap dipertahankan.
    RewriteEngine On
    RewriteCond %{HTTP_HOST} !^www\.k12\.com(?::80)?$ [NC]
    RewriteRule ^ http://www.k12.com%{REQUEST_URI} [R=301,L,NE]
    RewriteRule ^/?eternal$ /eternal/ [R=302,L]

    <Proxy "balancer://vault">
        BalancerMember "http://192.217.1.4:80" retry=1
        BalancerMember "http://192.217.1.5:80" retry=1
        ProxySet lbmethod=byrequests
    </Proxy>

    # Pengecualian dan path khusus HARUS berada sebelum proxy umum /.
    ProxyPass "/admin" "!"
    Alias /admin /var/www/admin
    <Directory /var/www/admin>
        Options -Indexes
        AllowOverride None
        Require all granted
    </Directory>
    <LocationMatch "^/admin(?:/|$)">
        AuthType Basic
        AuthName "Admin Penny"
        AuthBasicProvider file
        AuthUserFile /etc/apache2/.htpasswd
        Require user prabs
    </LocationMatch>

    ProxyPass        "/eternal/" "http://127.0.0.1:8080/"
    ProxyPassReverse "/eternal/" "http://127.0.0.1:8080/"
    ProxyPass        "/" "balancer://vault/"
    ProxyPassReverse "/" "balancer://vault/"
    ErrorLog /var/log/apache2/penny-error.log
    CustomLog /var/log/apache2/penny-access.log combined
</VirtualHost>

# Backend HTTP terpisah untuk /eternal, hanya mendengarkan loopback.
<VirtualHost 127.0.0.1:8080>
    ServerName eternal.internal
    DocumentRoot /var/www/eternal
    DirectoryIndex index.php
    RemoteIPHeader X-Real-IP
    RemoteIPInternalProxy 127.0.0.1
    <Directory /var/www/eternal>
        Options -Indexes
        AllowOverride None
        Require all granted
    </Directory>
    <FilesMatch "\.php$">
        SetHandler "proxy:unix:/run/php/php8.4-fpm.sock|fcgi://localhost/"
    </FilesMatch>
    ErrorLog /var/log/apache2/eternal-error.log
    CustomLog /var/log/apache2/eternal-access.log combined
</VirtualHost>
CONFIG
a2dissite 000-default.conf
a2ensite penny.conf
php_up
apache_up
