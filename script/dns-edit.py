#!/usr/bin/env python3
"""HANYA prab. Ubah zona nomor 17/18/19 dan selalu naikkan serial SOA."""
import argparse
import datetime
import os
from pathlib import Path
import re
import shutil
import socket
import subprocess
import tempfile

parser = argparse.ArgumentParser()
parser.add_argument('action', choices=['txt', 'ttl15', 'fake', 'restore', 'outbound'])
args = parser.parse_args()
if os.geteuid() != 0 or socket.gethostname().split('.')[0] != 'prab':
    raise SystemExit('Jalankan sebagai root hanya di console PRAB.')
zone = Path('/etc/bind/db.k12.com')
old = zone.read_text()
new = old
if args.action in {'ttl15', 'fake', 'restore'}:
    ip = '203.0.113.77' if args.action == 'fake' else '192.217.2.2'
    ttl = 300 if args.action == 'restore' else 15
    # Tepat satu A record Abbey. Record lain, termasuk CNAME static, tidak diubah.
    new, count = re.subn(
        r'^abbey(?:\.k12\.com\.)?\s+(?:\d+\s+)?IN\s+A\s+[^\s;]+[^\n]*$',
        f'abbey {ttl} IN A {ip}', new, flags=re.M | re.I)
    if count != 1:
        raise SystemExit(f'Ditemukan {count} A record abbey; periksa zona dahulu.')
elif args.action == 'txt':
    for name in ['alpha', 'beta', 'gamma', 'delta', 'epsilon']:
        pattern = rf'^{name}(?:\.k12\.com\.)?\s+(?:\d+\s+)?IN\s+TXT\s+[^\n]*\n?'
        new = re.sub(pattern, '', new, flags=re.M | re.I)
        new = new.rstrip() + f'\n{name} IN TXT "{name}"\n'
elif args.action == 'outbound':
    # CNAME tidak boleh hidup berdampingan dengan A/AAAA/TXT pada nama yang sama.
    pattern = r'^outbound(?:\.k12\.com\.)?\s+(?:\d+\s+)?IN\s+\S+\s+[^\n]*\n?'
    new = re.sub(pattern, '', new, flags=re.M | re.I)
    new = new.rstrip() + '\noutbound IN CNAME http.badssl.com.\n'

soa = re.compile(r'(\bSOA\s+\S+\s+\S+\s*\(\s*)(\d+)', re.I)
match = soa.search(new)
if not match:
    raise SystemExit('Format SOA tidak dikenali. Gunakan zona yang disiapkan 04-dns.sh.')
serial = max(int(match[2]) + 1, int(datetime.datetime.now().strftime('%Y%m%d') + '00'))
if serial > 4294967295:
    raise SystemExit('Serial melampaui uint32; periksa zona sebelum melanjutkan.')
new = soa.sub(lambda m: m[1] + str(serial), new, count=1)

stamp = datetime.datetime.now().strftime('%Y%m%d-%H%M%S-%f')
backup = Path('/root/lab-state/backups')
backup.mkdir(parents=True, exist_ok=True)
shutil.copy2(zone, backup / f'db.k12.com.{stamp}')
with tempfile.NamedTemporaryFile(mode='w', dir=zone.parent, prefix='db.k12.tmp.', delete=False) as f:
    f.write(new)
    temporary = Path(f.name)
try:
    subprocess.run(['named-checkzone', 'k12.com', str(temporary)], check=True)
    os.chmod(temporary, 0o644)
    os.replace(temporary, zone)
finally:
    temporary.unlink(missing_ok=True)
subprocess.run(['rndc', 'reload', 'k12.com'], check=True)
subprocess.run(['rndc', 'notify', 'k12.com'], check=True)
print(f'Aksi {args.action} selesai, serial baru {serial}. Bandingkan SOA prab dan tedd.')
