#!/bin/bash
set -e

cat >> /etc/bind/db.ramzy.com << 'EOF'

vault    IN      A       192.215.5.4
vault    IN      A       192.215.5.5
core     IN      A       192.215.5.6
core     IN      A       192.215.5.7

www      IN      CNAME   penny.ramzy.com.
static   IN      CNAME   abbey.ramzy.com.
EOF

sed -i 's/2         ; Serial/3         ; Serial/' /etc/bind/db.ramzy.com

named-checkzone ramzy.com /etc/bind/db.ramzy.com
rndc reload ramzy.com

echo "[prab] soal 7 zona updated, serial=3"