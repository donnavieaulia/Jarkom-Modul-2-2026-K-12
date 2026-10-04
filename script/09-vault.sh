#!/bin/bash
# HANYA obladi dan desmond. Nomor 9 + kesiapan 11 + real IP nomor 14.
set -euo pipefail
source "$(dirname -- "$0")/common.sh"
require_node obladi desmond
node=$(hostname -s)
install_pkgs apache2 curl procps
backup_paths /etc/apache2 /arsip /var/www/html
mkdir -p /arsip /var/www/html
[[ -f /arsip/contoh1.txt ]] || printf 'File contoh 1\n' > /arsip/contoh1.txt
[[ -f /arsip/contoh2.txt ]] || printf 'File contoh 2\n' > /arsip/contoh2.txt
[[ -f /var/www/html/index.html ]] || printf '<h1>Area vault K12</h1>\n' > /var/www/html/index.html
printf '%s\n' "$node" > /var/www/html/backend.txt
cat > /etc/apache2/sites-available/arsip.conf <<CONFIG
<VirtualHost *:80>
    ServerName $node.k12.com
    ServerAlias vault.k12.com www.k12.com penny.k12.com
    DocumentRoot /var/www/html
    Alias /arsip /arsip
    <Directory /arsip>
        Options +Indexes +FollowSymLinks
        DirectoryIndex disabled
        AllowOverride None
        Require all granted
    </Directory>
    RemoteIPHeader X-Real-IP
    RemoteIPInternalProxy 192.217.3.2
    LogFormat "client=%a peer=%{c}a host=%{Host}i %t request=%r status=%>s bytes=%b" lab_realip
    CustomLog /var/log/apache2/vault-access.log lab_realip
    ErrorLog /var/log/apache2/vault-error.log
    Header always set X-Backend "$node"
</VirtualHost>
CONFIG
a2enmod autoindex headers remoteip
a2dissite 000-default.conf
a2ensite arsip.conf
apache_up
