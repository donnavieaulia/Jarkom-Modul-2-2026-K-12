1.Execute di node prab
# Update & install BIND9
apt-get update && apt-get install -y bind9 bind9utils

# Set Options & Forwarder
cat <<'CONF' > /etc/bind/named.conf.options
options {
        directory "/var/cache/bind";
        forwarders { 192.168.122.1; };
        allow-query { any; };
        auth-nxdomain no;
        listen-on-v6 { any; };
};
CONF

# Deklarasi Zone Master k12.com
cat <<'CONF' > /etc/bind/named.conf.local
zone "k12.com" {
    type master;
    file "/etc/bind/jarkom/k12.com";
    allow-transfer { 192.217.5.3; };
    notify yes;
};
CONF

# Buat Folder & File DB Zone
mkdir -p /etc/bind/jarkom

cat <<'CONF' > /etc/bind/jarkom/k12.com
$TTL    604800
@       IN      SOA     prab.k12.com. root.k12.com. (
                                2026092901 ; Serial
                                    604800 ; Refresh
                                     86400 ; Retry
                                   2419200 ; Expire
                                    604800 ) ; Negative Cache TTL
;
@       IN      NS      prab.k12.com.
@       IN      NS      tedd.k12.com.

prab    IN      A       192.217.5.2
tedd    IN      A       192.217.5.3
@       IN      A       192.217.4.2
CONF

# Set Resolver Lokal
cat <<'CONF' > /etc/resolv.conf
nameserver 127.0.0.1
nameserver 192.217.5.2
nameserver 192.168.122.1
CONF

# Restart Service
service named restart || service bind9 restart

# Tes Resolusi Langsung dari Prab
host -t A k12.com

2.execute di node tedd
# Set Resolver sementara agar bisa download paket
echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Update & install BIND9
apt-get update && apt-get install -y bind9 bind9utils

# Set Options & Forwarder
cat <<'CONF' > /etc/bind/named.conf.options
options {
        directory "/var/cache/bind";
        forwarders { 192.168.122.1; };
        allow-query { any; };
        auth-nxdomain no;
        listen-on-v6 { any; };
};
CONF

# Deklarasi Zone Slave k12.com
cat <<'CONF' > /etc/bind/named.conf.local
zone "k12.com" {
    type slave;
    file "/var/lib/bind/k12.com";
    masters { 192.217.5.2; };
};
CONF

# Set Resolver Lokal
cat <<'CONF' > /etc/resolv.conf
nameserver 127.0.0.1
nameserver 192.217.5.3
nameserver 192.168.122.1
CONF

# Restart Service
service named restart || service bind9 restart

3.pengujian di node alpha
# Set Resolver Client mengarah ke Master & Slave
cat <<'CONF' > /etc/resolv.conf
nameserver 192.217.5.2
nameserver 192.217.5.3
nameserver 192.168.122.1
CONF

# Tes query ke Master
host -t A k12.com 192.217.5.2

# Tes query ke Slave
host -t A k12.com 192.217.5.3
