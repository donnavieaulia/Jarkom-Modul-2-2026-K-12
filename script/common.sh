#!/bin/bash
# Dipakai oleh skrip lainnya. Semua skrip harus berada di /root pada node GNS3.
set -euo pipefail
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
LAB_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
STATE=/root/lab-state
mkdir -p "$STATE/debs/partial" "$STATE/backups"
[[ $(id -u) == 0 ]] || { echo 'Jalankan sebagai root di console node GNS3.' >&2; exit 1; }
command -v apt-get >/dev/null || { echo 'Skrip ini untuk image Debian/debinet, bukan Alpine.' >&2; exit 1; }

require_node() {
    local actual
    actual=$(hostname -s)
    for allowed in "$@"; do
        [[ "$actual" == "$allowed" ]] && return 0
    done
    echo "SALAH NODE: sekarang $actual; jalankan pada: $*" >&2
    exit 1
}

backup_paths() {
    local dest path
    dest=$(mktemp -d "$STATE/backups/config.XXXXXXXX")
    for path in "$@"; do
        [[ ! -e "$path" ]] || cp -a --parents "$path" "$dest/"
    done
    echo "Backup konfigurasi: $dest"
}

install_pkgs() {
    # Cache .deb di /root agar dapat dipasang lagi setelah restart container.
    apt-get -o Acquire::Retries=3 update
    apt-get -o Acquire::Retries=3 -o Dir::Cache::archives="$STATE/debs" \
        -o APT::Keep-Downloaded-Packages=true install -y "$@"
    printf '%s\n' "$@" >> "$STATE/packages.txt"
    sort -u "$STATE/packages.txt" -o "$STATE/packages.txt"
}

apache_up() {
    mkdir -p /run/apache2 /var/log/apache2
    apache2ctl configtest
    if pgrep -x apache2 >/dev/null; then apache2ctl graceful; else apache2ctl start; fi
}

nginx_up() {
    mkdir -p /run /var/log/nginx
    nginx -t
    if pgrep -x nginx >/dev/null; then nginx -s reload; else nginx; fi
}

php_up() {
    mkdir -p /run/php
    php-fpm8.4 -t
    if [[ -f /run/php/php8.4-fpm.pid ]] && kill -0 "$(cat /run/php/php8.4-fpm.pid)" 2>/dev/null; then
        return 0
    fi
    php-fpm8.4 -D
}

named_up() {
    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named /var/cache/bind
    [[ -f /etc/bind/rndc.key ]] || rndc-confgen -a -u bind
    named-checkconf -z
    if pgrep -x named >/dev/null; then
        rndc reconfig
        rndc reload
    else
        named -u bind -c /etc/bind/named.conf
    fi
}

resolver_final() {
    cat > /etc/resolv.conf <<'RESOLVER'
nameserver 192.217.1.2
nameserver 192.217.1.3
nameserver 192.168.122.1
RESOLVER
}
