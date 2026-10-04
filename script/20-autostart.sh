#!/bin/bash
# Jalankan pada SETIAP node, setelah semua konfigurasi final (Abbey sudah restore).
set -euo pipefail
source "$(dirname -- "$0")/common.sh"
require_node rootkit alpha beta gamma delta epsilon prab tedd abbey penny obladi desmond oblada molly
role=$(hostname -s)
printf '%s\n' "$role" > /root/lab-role
packages=(iproute2 iputils-ping ifupdown procps curl dnsutils python3)
case "$role" in
    rootkit) packages+=(iptables udhcpc) ;;
    prab|tedd) packages+=(bind9 bind9-utils) ;;
    penny) packages+=(apache2 apache2-utils php8.4-fpm) ;;
    abbey) packages+=(nginx) ;;
    obladi|desmond) packages+=(apache2) ;;
    oblada|molly) packages+=(nginx php8.4-fpm) ;;
    alpha) packages+=(apache2-utils) ;;
esac
if [[ "$role" == prab ]]; then
    current=$(dig @127.0.0.1 abbey.k12.com A +short)
    [[ "$current" == 192.217.2.2 ]] || {
        echo 'Abbey belum normal. Jalankan python3 /root/dns-edit.py restore dahulu.' >&2; exit 1;
    }
fi
install_pkgs "${packages[@]}"

# Container GNS3 dapat kehilangan paket di layer nonvolume setelah stop/start.
# Unduh ulang paket BESERTA dependensi yang sudah terpasang ke volume /root.
mkdir -p "$STATE/boot-debs/partial"
apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts \
    --no-breaks --no-replaces --no-enhances "${packages[@]}" \
    | awk '/^[a-zA-Z0-9][a-zA-Z0-9.+:-]*$/ {print $1}' | sort -u > "$STATE/dependency-candidates.txt"
dependencies=()
while IFS= read -r package; do
    if [[ $(dpkg-query -W -f='${Status}' "$package" 2>/dev/null || true) == 'install ok installed' ]]; then
        dependencies+=("$package")
    fi
done < "$STATE/dependency-candidates.txt"
(( ${#dependencies[@]} > 0 )) || { echo 'Daftar dependensi kosong.' >&2; exit 1; }
apt-get -o Acquire::Retries=3 -o Dir::Cache::archives="$STATE/boot-debs" \
    --download-only --reinstall --no-install-recommends install -y "${dependencies[@]}"

# Simpan daftar paket wajib. Snapshot konfigurasi dipulihkan setiap kali start.
printf '%s\n' "${packages[@]}" | sort -u > "$STATE/boot-packages.txt"
paths=()
for path in etc/hostname etc/hosts etc/network/interfaces etc/network/if-up.d/zz-lab-resolver \
    etc/sysctl.d/99-lab-router.conf etc/bind etc/apache2 etc/nginx etc/php \
    var/www arsip var/cache/bind; do
    [[ ! -e "/$path" ]] || paths+=("$path")
done
tar -C / -czf "$STATE/config.tar.gz" "${paths[@]}"
cat > /root/boot.sh <<'BOOT'
#!/bin/bash
set -euo pipefail
exec >> /root/lab-boot.log 2>&1
echo "=== BOOT $(date -Is) ==="
source /root/common.sh
role=$(cat /root/lab-role)
need_packages=0
while IFS= read -r package; do
    [[ $(dpkg-query -W -f='${Status}' "$package" 2>/dev/null || true) == 'install ok installed' ]] || need_packages=1
done < "$STATE/boot-packages.txt"
if (( need_packages )); then
    shopt -s nullglob
    debs=("$STATE"/boot-debs/*.deb)
    (( ${#debs[@]} > 0 )) || { echo 'Cache paket kosong. Jalankan 20-autostart.sh lagi.' >&2; exit 1; }
    # Gunakan paket lokal sehingga DNS/router belum aktif pun tidak masalah.
    apt-get --no-download --no-install-recommends -y \
        -o Dpkg::Options::=--force-confold install "${debs[@]}"
fi
tar -C / --overwrite -xzf "$STATE/config.tar.gz"
bash /root/01-network.sh "$role" runtime
case "$role" in
    rootkit) bash /root/02-nat.sh runtime ;;
    prab|tedd) named_up ;;
    penny) php_up; apache_up ;;
    abbey) nginx_up ;;
    obladi|desmond) apache_up ;;
    oblada|molly) php_up; nginx_up ;;
esac
if [[ "$role" != rootkit ]]; then resolver_final; fi
echo "BOOT OK: $role $(date -Is)"
BOOT
chmod +x /root/boot.sh
echo 'Snapshot dan cache paket selesai.'
echo 'Set Start command GNS3 sesuai README, lalu buktikan dengan stop/start node.'
echo 'Setelah mengedit konfigurasi lagi, jalankan ulang 20-autostart.sh untuk memperbarui snapshot.'
