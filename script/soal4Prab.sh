mkdir -p /run/named
chown bind:bind /run/named
chown -R bind:bind /var/cache/bind
chown bind:bind /etc/bind/db.k12.com

named-checkconf
named-checkzone k12.com /etc/bind/db.k12.com

pkill named 2>/dev/null || true
sleep 1
named -u bind -c /etc/bind/named.conf

echo "nameserver 127.0.0.1" > /etc/resolv.conf
echo "[prab] setup done
