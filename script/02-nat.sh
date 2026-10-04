#!/bin/bash
# HANYA rootkit. Mode runtime digunakan otomatis ketika node start.
set -euo pipefail
source "$(dirname -- "$0")/common.sh"
require_node rootkit
if [[ ${1:-configure} != runtime ]]; then install_pkgs iptables iproute2 ifupdown udhcpc procps; fi
mkdir -p /etc/sysctl.d
printf 'net.ipv4.ip_forward=1\n' > /etc/sysctl.d/99-lab-router.conf
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -C POSTROUTING -s 192.217.0.0/16 -o eth0 -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING -s 192.217.0.0/16 -o eth0 -j MASQUERADE
iptables -C FORWARD -s 192.217.0.0/16 -j ACCEPT 2>/dev/null || \
    iptables -I FORWARD 1 -s 192.217.0.0/16 -j ACCEPT
iptables -C FORWARD -d 192.217.0.0/16 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT 2>/dev/null || \
    iptables -I FORWARD 1 -d 192.217.0.0/16 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -S POSTROUTING
