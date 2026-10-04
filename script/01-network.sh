#!/bin/bash
# Opsional: konfigurasi ulang nomor 1, 3, 5. Panggil: bash 01-network.sh NAMA_NODE
set -euo pipefail
source "$(dirname -- "$0")/common.sh"
node=${1:?Contoh: bash /root/01-network.sh alpha}
mode=${2:-configure}
case "$node" in
    rootkit) address=192.217.1.1 ;;
    prab) address=192.217.1.2 ;; tedd) address=192.217.1.3 ;;
    obladi) address=192.217.1.4 ;; desmond) address=192.217.1.5 ;;
    oblada) address=192.217.1.6 ;; molly) address=192.217.1.7 ;;
    abbey) address=192.217.2.2 ;; penny) address=192.217.3.2 ;;
    alpha) address=192.217.4.2 ;; beta) address=192.217.4.3 ;; gamma) address=192.217.4.4 ;;
    delta) address=192.217.5.2 ;; epsilon) address=192.217.5.3 ;;
    *) echo "Nama node tidak dikenal: $node" >&2; exit 1 ;;
esac
if [[ "$mode" != runtime ]]; then
    backup_paths /etc/network/interfaces /etc/hostname /etc/hosts /etc/resolv.conf
    printf '%s\n' "$node" > /etc/hostname
    printf '%s\n' "$node" > /root/lab-role
    # /etc/hosts dapat merupakan bind mount; tulis isinya, jangan sed -i.
    awk '$1 != "127.0.1.1"' /etc/hosts > /tmp/lab-hosts
    printf '127.0.1.1 %s.k12.com %s\n' "$node" "$node" >> /tmp/lab-hosts
    cat /tmp/lab-hosts > /etc/hosts
    cat > /etc/network/interfaces <<'LOOPBACK'
auto lo
iface lo inet loopback
LOOPBACK
    if [[ "$node" == rootkit ]]; then
        cat >> /etc/network/interfaces <<'WAN'

auto eth0
iface eth0 inet dhcp
WAN
        for seg in 1 2 3 4 5; do
            cat >> /etc/network/interfaces <<NET

auto eth${seg}
iface eth${seg} inet static
    address 192.217.${seg}.1
    netmask 255.255.255.0
NET
        done
    else
        cat >> /etc/network/interfaces <<NET

auto eth0
iface eth0 inet static
    address $address
    netmask 255.255.255.0
    gateway ${address%.*}.1
    up /bin/sh -c 'printf "nameserver 192.168.122.1\\n" > /etc/resolv.conf'
NET
    fi
fi
hostname "$node"
ip link set lo up
if [[ "$node" == rootkit ]]; then
    for seg in 1 2 3 4 5; do
        ip link set "eth$seg" up
        ip address replace "192.217.$seg.1/24" dev "eth$seg"
    done
    ip link set eth0 up
    if ! ip -4 route show default | grep -q 'dev eth0'; then
        if command -v udhcpc >/dev/null; then
            udhcpc -i eth0 -n -q
        elif command -v ifup >/dev/null; then
            ifup --force eth0
        elif command -v dhclient >/dev/null; then
            dhclient eth0
        else
            echo 'WAN eth0 belum memperoleh DHCP. Aktifkan DHCP melalui konfigurasi network GNS3.' >&2
            exit 1
        fi
    fi
else
    ip link set eth0 up
    ip address replace "$address/24" dev eth0
    ip route replace default via "${address%.*}.1" dev eth0
fi
printf 'nameserver 192.168.122.1\n' > /etc/resolv.conf
ip -br -4 address
ip -4 route
