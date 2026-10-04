# Jarkom-Modul-2-2026-K-21

| Nama                          | NRP        |
| ----------------------------- | ---------- |
| Donnavie Aulia                | 5027251093 |
| Ndaru Satria Tama             | 5027251124 |



## Topologi dan Pembagian IP
<img width="2044" height="1286" alt="Screenshot 2026-10-04 at 22 24 47" src="https://github.com/user-attachments/assets/c4b7e53d-968c-452b-b06e-46467e25f73c" />


| Node | Peran | Interface | IP / Prefix | Gateway | Switch |
|---|---|---|---|---|---|
| rootkit | Router sentral | eth0 | DHCP (NAT) | DHCP (NAT) | NAT |
| rootkit | | eth1 | 192.217.1.1/24 | - | Switch1 |
| rootkit | | eth2 | 192.217.2.1/24 | - | Switch4 |
| rootkit | | eth3 | 192.217.3.1/24 | - | Switch5 |
| rootkit | | eth4 | 192.217.4.1/24 | - | Switch6 |
| rootkit | | eth5 | 192.217.5.1/24 | - | Switch7 |
| prab | DNS master (ns1) | eth0 | 192.217.1.2/24 | 192.217.1.1 | Switch2 |
| tedd | DNS slave (ns2) | eth0 | 192.217.1.3/24 | 192.217.1.1 | Switch2 |
| obladi | Web statis (vault) | eth0 | 192.217.1.4/24 | 192.217.1.1 | Switch3 |
| desmond | Web statis (vault) | eth0 | 192.217.1.5/24 | 192.217.1.1 | Switch3 |
| oblada | Web dinamis (core) | eth0 | 192.217.1.6/24 | 192.217.1.1 | Switch3 |
| molly | Web dinamis (core) | eth0 | 192.217.1.7/24 | 192.217.1.1 | Switch3 |
| abbey | Reverse proxy (Nginx) | eth0 | 192.217.2.2/24 | 192.217.2.1 | Switch4 |
| penny | Reverse proxy (Apache) | eth0 | 192.217.3.2/24 | 192.217.3.1 | Switch5 |
| alpha | Klien sayap kiri | eth0 | 192.217.4.2/24 | 192.217.4.1 | Switch6 |
| beta | Klien sayap kiri | eth0 | 192.217.4.3/24 | 192.217.4.1 | Switch6 |
| gamma | Klien sayap kiri | eth0 | 192.217.4.4/24 | 192.217.4.1 | Switch6 |
| delta | Klien sayap kanan | eth0 | 192.217.5.2/24 | 192.217.5.1 | Switch7 |
| epsilon | Klien sayap kanan | eth0 | 192.217.5.3/24 | 192.217.5.1 | Switch7 |



## Soal 1
### IP Address dan Default Gateway

**Soal:** Rootkit dihubungkan ke lima switch. Tetapkan IP dan default gateway untuk seluruh entitas (alpha, beta, gamma, delta, epsilon, prab, tedd, abbey, penny, obladi, desmond, oblada, molly) sesuai topologi, dengan prefix IP kelompok.

**Script:**

- [`script/01-network.sh`](script/01-network.sh) - Menulis hostname, `/etc/hosts`, `/etc/network/interfaces`, lalu menerapkan IP/gateway secara runtime.

**Cara menjalankan:**

Di setiap node (sesuai hostname):

```bash
bash /root/01-network.sh "$(hostname -s)"
```

**Penjelasan:** Skrip membaca nama node lalu memilih alamat dari tabel. Rootkit memakai `eth0` DHCP (ke NAT) dan `eth1`-`eth5` sebagai gateway tiap segmen (`192.217.1.1` s.d. `192.217.5.1`). Node lain memakai `eth0` statis `/24` dengan gateway `.1` pada segmen masing-masing. Konfigurasi ditulis ke `/etc/network/interfaces` agar persisten, lalu diterapkan langsung dengan `ip address replace` dan `ip route replace`.


**CONSOLE ROOTKIT.**

```bash
date -Is
hostname
ip -br -4 address
ip -4 route
```

**SETIAP NODE NON-ROUTER, SATU PER SATU.**

```bash
date -Is
hostname
ip -br -4 address
ip -4 route
gateway=$(ip -4 route show default | awk 'NR == 1 {print $3}')
if [ -n "$gateway" ]; then
    ping -c 2 -W 2 "$gateway"
else
    echo 'GAGAL: default gateway belum ditemukan.'
fi
```

**Target hasil:** IP dan gateway harus sesuai tabel; ping gateway mendapat balasan. Non-router berarti seluruh node di atas selain Rootkit.

## Konfigurasi Jaringan

- rootkit

```text
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 192.217.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 192.217.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 192.217.3.1
    netmask 255.255.255.0

auto eth4
iface eth4 inet static
    address 192.217.4.1
    netmask 255.255.255.0

auto eth5
iface eth5 inet static
    address 192.217.5.1
    netmask 255.255.255.0
```

- prab

```text
auto eth0
iface eth0 inet static
    address 192.217.1.2
    netmask 255.255.255.0
    gateway 192.217.1.1
```

- tedd

```text
auto eth0
iface eth0 inet static
    address 192.217.1.3
    netmask 255.255.255.0
    gateway 192.217.1.1
```

- obladi

```text
auto eth0
iface eth0 inet static
    address 192.217.1.4
    netmask 255.255.255.0
    gateway 192.217.1.1
```

- desmond

```text
auto eth0
iface eth0 inet static
    address 192.217.1.5
    netmask 255.255.255.0
    gateway 192.217.1.1
```

- oblada

```text
auto eth0
iface eth0 inet static
    address 192.217.1.6
    netmask 255.255.255.0
    gateway 192.217.1.1
```

- molly

```text
auto eth0
iface eth0 inet static
    address 192.217.1.7
    netmask 255.255.255.0
    gateway 192.217.1.1
```

- abbey

```text
auto eth0
iface eth0 inet static
    address 192.217.2.2
    netmask 255.255.255.0
    gateway 192.217.2.1
```

- penny

```text
auto eth0
iface eth0 inet static
    address 192.217.3.2
    netmask 255.255.255.0
    gateway 192.217.3.1
```

- alpha

```text
auto eth0
iface eth0 inet static
    address 192.217.4.2
    netmask 255.255.255.0
    gateway 192.217.4.1
```

- beta

```text
auto eth0
iface eth0 inet static
    address 192.217.4.3
    netmask 255.255.255.0
    gateway 192.217.4.1
```

- gamma

```text
auto eth0
iface eth0 inet static
    address 192.217.4.4
    netmask 255.255.255.0
    gateway 192.217.4.1
```

- delta

```text
auto eth0
iface eth0 inet static
    address 192.217.5.2
    netmask 255.255.255.0
    gateway 192.217.5.1
```

- epsilon

```text
auto eth0
iface eth0 inet static
    address 192.217.5.3
    netmask 255.255.255.0
    gateway 192.217.5.1
```

## Soal 2
### NAT dan Akses Internet

**Soal:** Aktifkan antarmuka WAN rootkit dan konfigurasikan NAT agar seluruh alamat internal dapat menjangkau internet publik menggunakan IP address.

**Script:**

- [`script/02-nat.sh`](script/02-nat.sh) - Mengaktifkan `ip_forward`, menambah aturan `MASQUERADE` dan aturan `FORWARD`.

**Cara menjalankan:**

Di rootkit:

```bash
bash /root/02-nat.sh
```

**Penjelasan:** `net.ipv4.ip_forward=1` dibuat permanen lewat `/etc/sysctl.d/99-lab-router.conf`. Aturan `iptables -t nat -A POSTROUTING -s 192.217.0.0/16 -o eth0 -j MASQUERADE` meneruskan trafik internal keluar lewat WAN. Aturan `FORWARD` mengizinkan trafik dari jaringan internal serta balasan `ESTABLISHED,RELATED`. Setiap aturan dicek dulu dengan `-C` sehingga skrip aman dijalankan berulang.


**CONSOLE ROOTKIT.**

```bash
# PASTE DI CONSOLE ROOTKIT
hostname
ip -4 address show eth0
ip -4 route show default
sysctl net.ipv4.ip_forward
iptables -t nat -S POSTROUTING
iptables -S FORWARD
```

**SETIAP NODE NON-ROUTER, SATU PER SATU.**

```bash
# PASTE DI SETIAP NODE NON-ROUTER, SATU PER SATU
hostname
ping -c 3 -W 2 1.1.1.1
```

**Target hasil:** IP forwarding bernilai 1, MASQUERADE keluar eth0, dan host internal dapat melakukan ping ke 1.1.1.1.
<img width="1286" height="1078" alt="2 abbey" src="https://github.com/user-attachments/assets/63b51e7d-33d4-4bd5-ab2a-2cec85921446" />
<img width="1288" height="1078" alt="2 alpha" src="https://github.com/user-attachments/assets/3d956b01-9990-4f74-8030-283b23689958" />


## Soal 3
### Routing Internal dan Resolver Awal

**Soal:** Pastikan seluruh entitas dapat saling berkomunikasi lintas segmen lewat rootkit, dan setiap host non-router memakai resolver `192.168.122.1` agar dapat mengunduh paket sejak awal.

**Script:**

- [`script/03-resolver-awal.sh`](script/03-resolver-awal.sh) - Menulis resolver awal dan memasang `curl`, `dnsutils`, `iputils-ping`.
- [`script/common.sh`](script/common.sh) - Fungsi bersama (`install_pkgs`, `require_node`, `apache_up`, dst.) yang dipakai semua skrip.

**Cara menjalankan:**

Buat `common.sh` di semua 14 node terlebih dahulu:

```bash
cat /root/common.sh | head -5  
```

Di setiap node non-router:

```bash
bash /root/03-resolver-awal.sh
```

**Penjelasan:** Routing antarsegmen berjalan karena setiap node memakai rootkit sebagai gateway (nomor 1) dan rootkit meneruskan paket (nomor 2). `install_pkgs` pada `common.sh` menyimpan cache `.deb` di `/root/lab-state/debs` agar paket bisa dipasang ulang setelah restart.

#### Verifikasi (jalankan lalu screenshot)

**ALPHA, LALU ULANGI DI DELTA DAN HOST LAIN UNTUK BUKTI LENGKAP.**

```bash
hostname
for ip in 192.217.1.1 192.217.1.2 192.217.1.3 192.217.1.4 192.217.1.5 192.217.1.6 192.217.1.7 192.217.2.2 192.217.3.2 192.217.4.2 192.217.4.3 192.217.4.4 192.217.5.2 192.217.5.3; do
    printf '\nTujuan %s\n' "$ip"
    ping -c 1 -W 2 "$ip"
done
cat /etc/resolv.conf
```

**Target hasil:** Ping antarsegmen membuktikan routing melalui Rootkit. Setelah konfigurasi lengkap, resolver non-router harus berurutan Prab, Tedd, lalu NAT.

<img width="1287" height="1078" alt="3 delta" src="https://github.com/user-attachments/assets/939a3b51-ffce-4a56-a162-8dd525039b37" />


## Soal 4
### DNS Master (prab) dan Slave (tedd)

**Soal:** Bangun zona `k12.com` pada prab (SOA ke prab, NS prab dan tedd, A record prab, tedd, apex ke penny), aktifkan notify dan allow-transfer ke tedd, set forwarders `192.168.122.1`. Tedd menarik zona sebagai slave. Urutan resolver seluruh non-router menjadi prab, tedd, `192.168.122.1`.

**Script:**

- [`script/04-dns.sh`](script/04-dns.sh) - Membuat konfigurasi BIND untuk prab (master) atau tedd (slave) berdasarkan hostname; sekaligus zona nomor 5, 7, 8.
- [`script/03-resolver.sh`](script/03-resolver.sh) - Resolver akhir: prab, tedd, lalu `192.168.122.1`, ditambah hook `if-up.d`.

**Cara menjalankan:**

Di prab, lalu tedd:

```bash
bash /root/04-dns.sh
```

Di semua node non-router (setelah prab dan tedd aktif):

```bash
bash /root/03-resolver.sh
```

**Penjelasan:** `named.conf.options` memuat `forwarders { 192.168.122.1; }` dan membatasi query/recursion ke ACL `lab`. Pada prab, zona `k12.com` bertipe `master` dengan `notify yes`, `also-notify` dan `allow-transfer` ke `192.217.1.3`. SOA menunjuk `prab.k12.com.` dengan serial berformat `YYYYMMDDnn`. A record apex diarahkan ke `192.217.3.2` (penny). Tedd bertipe `slave` dengan `masters { 192.217.1.2; }` sehingga jawaban Tedd authoritative (flag `aa`).


**CONSOLE PRAB.**

```bash
hostname
named-checkconf
named-checkzone k12.com /etc/bind/db.k12.com
cat /etc/bind/named.conf.local
cat /etc/bind/named.conf.options
```

**CONSOLE ALPHA.**

```bash
hostname
for dns in 192.217.1.2 192.217.1.3; do
    printf '\nDNS %s\n' "$dns"
    dig @"$dns" k12.com SOA +norecurse +noall +comments +answer
    dig @"$dns" k12.com NS +norecurse +noall +comments +answer
    dig @"$dns" k12.com A +norecurse +noall +comments +answer
    dig @"$dns" prab.k12.com A +short
    dig @"$dns" tedd.k12.com A +short
done
```

**Target hasil:** SOA menunjuk Prab, NS Prab/Tedd tersedia, apex k12.com ke 192.217.3.2, dan respons kedua DNS memiliki NOERROR serta flag aa. Transfer/notify Prab menuju Tedd 192.217.1.3.

<img width="1286" height="1078" alt="4 alpha" src="https://github.com/user-attachments/assets/764920b7-7ae4-4476-86bf-98ced1261219" />

<img width="1286" height="1078" alt="4 prab" src="https://github.com/user-attachments/assets/a0649cf1-6a87-4729-99cd-d8d5be4d4982" />


## Soal 5
### Hostname Sistem dan A Record Seluruh Node

**Soal:** Namai semua entitas sesuai glosarium, pastikan setiap host mengenali hostname-nya secara system-wide, buat domain tiap node (contoh `alpha.k12.com`) beserta IP-nya. Prab dan tedd dikecualikan dari duplikasi.

**Script:**

- [`script/01-network.sh`](script/01-network.sh) - Menulis `/etc/hostname` dan entri `/etc/hosts`.
- [`script/04-dns.sh`](script/04-dns.sh) - Membuat A record seluruh node di zona `k12.com`.



**Penjelasan:** Hostname dibuat oleh `01-network.sh` (menulis `/etc/hostname`, menjalankan `hostname`, dan menambahkan `127.0.1.1 <node>.k12.com <node>` ke `/etc/hosts`). A record `rootkit` hingga `epsilon` ditulis oleh `04-dns.sh`; record prab dan tedd hanya ditulis sekali.



**SEMUA 14 NODE, SATU PER SATU.**

```bash
hostname
cat /etc/hostname
getent hosts "$(hostname -s)"
```

**CONSOLE ALPHA.**

```bash
for host in rootkit alpha beta gamma delta epsilon prab tedd abbey penny obladi desmond oblada molly; do
    printf '\n%s.k12.com\n' "$host"
    dig @192.217.1.2 "$host.k12.com" A +short
done
```

**Target hasil:** Hostname sistem harus sesuai nama node, dan dig harus menghasilkan IP pada tabel nomor 1. getent dapat membaca /etc/hosts; dig membuktikan data DNS.



## Soal 6
### Zone Transfer dan Serial SOA

**Soal:** Pastikan tedd telah menerima salinan zona terbaru dari prab dan nilai serial SOA keduanya sama.

**Script:**

- [`script/04-dns.sh`](script/04-dns.sh) - Konfigurasi notify/allow-transfer di prab dan slave di tedd; `rndc retransfer` pada tedd.


**Penjelasan:** Prab mengirim `NOTIFY` ke tedd dan mengizinkan transfer hanya untuk `192.217.1.3`. Tedd menarik zona via AXFR dari `192.217.1.2` dan menyimpannya di `/var/cache/bind`. Kesamaan serial SOA dan flag `aa` membuktikan zona tersinkron.

#### Verifikasi (jalankan lalu screenshot)

**CONSOLE ALPHA.**

```bash
echo 'SOA PRAB:'
dig @192.217.1.2 k12.com SOA +short
echo 'SOA TEDD:'
dig @192.217.1.3 k12.com SOA +short
echo 'AUTHORITATIVE TEDD:'
dig @192.217.1.3 k12.com A +norecurse +noall +comments +answer
```

**CONSOLE TEDD.**

```bash
hostname
dig @192.217.1.2 k12.com AXFR
```

**Target hasil:** serial SOA Prab dan Tedd sama, AXFR dari Tedd berhasil, dan Tedd menjawab authoritative dengan flag aa.


## Soal 7
### Record vault, core, dan CNAME

**Soal:** Tambahkan A record `vault` (obladi dan desmond), `core` (oblada dan molly), serta CNAME `www` ke `penny` dan `static` ke `abbey`. Verifikasi dari dua klien berbeda.

**Script:**

- [`script/04-dns.sh`](script/04-dns.sh) - Menambah record `vault`, `core`, `www`, `static` pada zona `k12.com`.


**Penjelasan:** `vault` memiliki dua A record (`192.217.1.4`, `192.217.1.5`) dan `core` dua A record (`192.217.1.6`, `192.217.1.7`) sehingga DNS round-robin. `www` adalah CNAME ke `penny.k12.com.` dan `static` CNAME ke `abbey.k12.com.`.


**CONSOLE ALPHA, LALU ULANGI DI DELTA.**

```bash
hostname
dig vault.k12.com A +noall +answer
dig core.k12.com A +noall +answer
dig www.k12.com CNAME +noall +answer
dig www.k12.com A +noall +answer
dig static.k12.com CNAME +noall +answer
dig static.k12.com A +noall +answer
```

**Target hasil:** Alpha dan Delta harus memperoleh kumpulan alamat yang sama. Urutan dua A record boleh bertukar. WWW berakhir pada IP Penny; static pada IP Abbey.


## Soal 8
### Reverse DNS (PTR)

**Soal:** Deklarasikan reverse zone untuk segmen abbey, penny, area vault, dan area core di prab (master) dan tedd (slave), isi PTR keempat hostname, lalu pastikan query reverse dijawab authoritative.

**Script:**

- [`script/04-dns.sh`](script/04-dns.sh) - Membuat reverse zone `1.217.192`, `2.217.192`, `3.217.192` beserta PTR.


**Penjelasan:** Tiga reverse zone dibuat: `1.217.192.in-addr.arpa` (rootkit, prab, tedd, obladi, desmond, oblada, molly), `2.217.192.in-addr.arpa` (abbey), dan `3.217.192.in-addr.arpa` (penny). Tedd menarik ketiganya sebagai slave.


**CONSOLE ALPHA.**

```bash
for dns in 192.217.1.2 192.217.1.3; do
    for ip in 192.217.2.2 192.217.3.2 192.217.1.4 192.217.1.5 192.217.1.6 192.217.1.7; do
        printf '\nDNS %s, reverse %s\n' "$dns" "$ip"
        dig @"$dns" -x "$ip" +norecurse +noall +comments +answer
    done
done
```

**Target hasil:** reverse IP Abbey, Penny, Obladi, Desmond, Oblada, dan Molly menghasilkan hostname yang sesuai, dengan flag aa pada kedua DNS.


#### Hasil

**alpha** - DNS 192.217.1.2: PTR abbey, penny, obladi, desmond, oblada, molly + flag `aa`

![Soal 8 - alpha](images/08/08-alpha-reverse-1.png)

**alpha** - DNS 192.217.1.3: PTR yang sama + flag `aa`

![Soal 8 - alpha](images/08/08-alpha-reverse-2.png)

---

## Soal 9
### Web Statis Apache dan Autoindex /arsip

**Soal:** Jalankan web statis memakai Apache pada node area vault (obladi, desmond). Buka direktori `/arsip/` dengan autoindex. Pengujian lewat hostname.

**Script:**

- [`script/09-vault.sh`](script/09-vault.sh) - Pasang Apache, buat `/arsip`, VirtualHost `arsip.conf`, aktifkan `autoindex`, `headers`, `remoteip`.

**Cara menjalankan:**

Di obladi, lalu desmond:

```bash
bash /root/09-vault.sh
```

**Penjelasan:** `Alias /arsip /arsip` dengan `Options +Indexes` menampilkan daftar file. Skrip membuat `contoh1.txt` dan `contoh2.txt` sebagai isi arsip, dan header `X-Backend` untuk menandai backend yang melayani. Konfigurasi `RemoteIPHeader` untuk nomor 14 ikut dibuat di sini.

#### Verifikasi (jalankan lalu screenshot)

**CONSOLE ALPHA.**

```bash
curl --noproxy '*' --max-time 10 -sS -i http://obladi.k12.com/arsip/
curl --noproxy '*' --max-time 10 -sS -i http://desmond.k12.com/arsip/
```

**CONSOLE OBLADI, LALU ULANGI DI DESMOND.**

```bash
hostname
apache2ctl configtest
cat /etc/apache2/sites-available/arsip.conf
ls -l /arsip
```

**Target hasil:** akses /arsip/ melalui hostname menghasilkan HTTP 200 dan daftar file. Autoindex diaktifkan pada kedua backend vault.

#### Hasil

**alpha** - HTTP 200 dan HTML "Index of /arsip" dengan contoh1.txt, contoh2.txt

![Soal 9 - alpha](images/09/09-alpha-curl-arsip.png)

**obladi** - `Syntax OK`, isi `arsip.conf`, `ls -l /arsip`

![Soal 9 - obladi](images/09/09-obladi-config.png)

**desmond** - `Syntax OK`, isi `arsip.conf`, `ls -l /arsip`

![Soal 9 - desmond](images/09/09-desmond-config.png)

---

## Soal 10
### Web Dinamis Nginx + PHP-FPM dan URL /profil

**Soal:** Jalankan web dinamis (PHP-FPM) dengan nginx pada node area core (oblada, molly). Buat halaman beranda dan profil, dan terapkan rewrite agar `/profil` bekerja tanpa `.php`. Pengujian lewat hostname.

**Script:**

- [`script/10-core.sh`](script/10-core.sh) - Pasang nginx dan php8.4-fpm, buat `index.php`, `profil.php`, dan server block `core.conf`.

**Cara menjalankan:**

Di oblada, lalu molly:

```bash
bash /root/10-core.sh
```

**Penjelasan:** Aplikasi berada di `/var/www/core`. Blok `location = /profil { rewrite ^ /profil.php last; }` membuat URL bersih `/profil`. PHP dieksekusi lewat `fastcgi_pass unix:/run/php/php8.4-fpm.sock`.



**CONSOLE ALPHA.**

```bash
for host in oblada molly; do
    printf '\nBERANDA %s\n' "$host"
    curl --noproxy '*' --max-time 10 -sS -i "http://$host.k12.com/"
    printf '\nPROFIL %s\n' "$host"
    curl --noproxy '*' --max-time 10 -sS -i "http://$host.k12.com/profil"
done
```

**CONSOLE OBLADA, LALU ULANGI DI MOLLY.**

```bash
hostname
nginx -t
php-fpm8.4 -t
cat /etc/nginx/sites-available/core.conf
```

**Target hasil:** beranda dan /profil menghasilkan HTTP 200 serta HTML hasil eksekusi PHP. Rewrite last meneruskan /profil ke handler /profil.php.

#### Hasil

**alpha** - HTTP 200, HTML beranda dan profil hasil eksekusi PHP

![Soal 10 - alpha](images/10/10-alpha-oblada.png)

**alpha** - HTTP 200, HTML beranda dan profil

![Soal 10 - alpha](images/10/10-alpha-molly.png)

**oblada** - `nginx -t` ok, `php-fpm8.4 -t` ok, isi `core.conf` (ada rewrite)

![Soal 10 - oblada](images/10/10-oblada-config.png)

**molly** - `nginx -t` ok, `php-fpm8.4 -t` ok, isi `core.conf`

![Soal 10 - molly](images/10/10-molly-config.png)

---

## Soal 11
### Reverse Proxy Penny (Apache) dan Abbey (Nginx)

**Soal:** Penny (Apache) menjadi reverse proxy ke area vault (obladi, desmond); Abbey (Nginx) menjadi reverse proxy ke area core (oblada, molly). Teruskan header Host dan X-Real-IP, dan buktikan trafik terdistribusi.

**Script:**

- [`script/11-penny.sh`](script/11-penny.sh) - Apache reverse proxy + load balancer ke vault, juga konfigurasi nomor 12, 13, 15.
- [`script/11-abbey.sh`](script/11-abbey.sh) - Nginx reverse proxy + upstream ke core, juga konfigurasi nomor 13 dan 15.

**Cara menjalankan:**

Di penny:

```bash
bash /root/11-penny.sh
```

Di abbey:

```bash
bash /root/11-abbey.sh
```

**Penjelasan:** Penny memakai `balancer://vault` (metode `byrequests`) ke `192.217.1.4` dan `192.217.1.5`, `ProxyPreserveHost On` meneruskan Host, dan `RequestHeader set X-Real-IP` meneruskan IP client. Abbey memakai `upstream core_backend` ke `192.217.1.6` dan `192.217.1.7`, dengan `proxy_set_header Host $http_host` dan `X-Real-IP $remote_addr`. Header `X-Backend` pada backend menunjukkan node yang menjawab.


**CONSOLE ALPHA.**

```bash
for host in www.k12.com static.k12.com; do
    printf '\n=== %s ===\n' "$host"
    for i in $(seq 1 10); do
        printf 'Request %s\n' "$i"
        curl --noproxy '*' --max-time 10 -sS -D - -o /dev/null "http://$host/" \
            | tr -d '\r' | grep -Ei '^(HTTP/|X-Backend:)'
    done
done
```

**CONSOLE PENNY.**

```bash
hostname
apache2ctl configtest
grep -nE 'ProxyPreserveHost|X-Real-IP|BalancerMember|lbmethod' /etc/apache2/sites-available/penny.conf
```

**CONSOLE ABBEY.**

```bash
hostname
nginx -t
grep -nE 'upstream|server 192|proxy_pass|proxy_set_header' /etc/nginx/sites-available/abbey.conf
```

**Target hasil:** WWW dilayani Obladi dan Desmond, static dilayani Oblada dan Molly. Kedua proxy meneruskan Host dan X-Real-IP. Urutan backend tidak harus bergantian persis.


## Soal 12
### Basic Authentication /admin di Penny

**Soal:** Lindungi path `/admin` pada penny dengan basic authentication. Hanya kredensial `prabs` / `pakar_pinter_jadi_gob***` yang diizinkan.

**Script:**

- [`script/11-penny.sh`](script/11-penny.sh) - Membuat `.htpasswd` untuk user `prabs` dan blok `LocationMatch ^/admin`.


**Penjelasan:** Password disimpan dalam `/etc/apache2/.htpasswd` (bcrypt, `htpasswd -iBc`). Tiga tanda `*` pada password adalah karakter literal. `ProxyPass "/admin" "!"` mengecualikan path admin dari proxy sehingga dilayani langsung dari `/var/www/admin`.


**CONSOLE ALPHA.**

```bash
echo 'TANPA KREDENSIAL:'
curl --noproxy '*' --max-time 10 -sS -D - -o /dev/null http://www.k12.com/admin/
echo 'PASSWORD SALAH:'
curl --noproxy '*' --max-time 10 -sS -D - -o /dev/null -u 'prabs:salah' http://www.k12.com/admin/
echo 'KREDENSIAL BENAR:'
curl --noproxy '*' --max-time 10 -sS -i -u 'prabs:pakar_pinter_jadi_gob***' http://www.k12.com/admin/
echo 'TANPA SLASH, TANPA KREDENSIAL:'
curl --noproxy '*' --max-time 10 -sS -D - -o /dev/null http://www.k12.com/admin
```

**Target hasil:** tanpa kredensial atau password salah mendapat 401. Kredensial benar mendapat 200 dan halaman Admin Penny. /admin tanpa slash tetap terlindungi.



## Soal 13
### Redirect Kanonik 301 / 302

**Soal:** Akses ke IP penny atau `penny.k12.com` harus redirect permanen (301) ke `www.k12.com`. Akses ke IP abbey atau `abbey.k12.com` harus redirect sementara (302) ke `static.k12.com`.

**Script:**

- [`script/11-penny.sh`](script/11-penny.sh) - `RewriteCond`/`RewriteRule` ... `R=301`.
- [`script/11-abbey.sh`](script/11-abbey.sh) - Server `default_server` ... `return 302`.

**Cara menjalankan:**

Sudah termasuk 11-penny.sh dan 11-abbey.sh:


**Penjelasan:** Penny: host selain `www.k12.com` di-redirect `301` ke `http://www.k12.com%{REQUEST_URI}` (path dan query dipertahankan). Abbey: server block `default_server` mengembalikan `302` ke `http://static.k12.com$request_uri`.


**CONSOLE ALPHA.**

```bash
for url in http://192.217.3.2/ http://penny.k12.com/ http://192.217.2.2/ http://abbey.k12.com/; do
    printf '\nURL %s\n' "$url"
    curl --noproxy '*' --max-time 10 -sS -I "$url"
done
curl --noproxy '*' --max-time 10 -sS -I 'http://penny.k12.com/arsip/?cek=1'
curl --noproxy '*' --max-time 10 -sS -I 'http://abbey.k12.com/profil?cek=1'
```

**Target hasil:** Periksa status dan header Location. Path serta query string harus ikut dipertahankan. Check tidak memakai -L agar status redirect awal terlihat.


## Soal 14
### Log IP Asli Client

**Soal:** Access log pada setiap web server di area vault dan area core harus mencatat IP asli client yang diteruskan gerbang, bukan IP penny atau abbey.

**Script:**

- [`script/09-vault.sh`](script/09-vault.sh) - `RemoteIPHeader X-Real-IP` + `RemoteIPInternalProxy 192.217.3.2` + log `lab_realip`.
- [`script/10-core.sh`](script/10-core.sh) - `set_real_ip_from 192.217.2.2` + `real_ip_header X-Real-IP` + log `lab_realip`.

**Cara menjalankan:**

Sudah termasuk 09-vault.sh dan 10-core.sh:


**Penjelasan:** Format log menampilkan `client=` (IP asli setelah modul remoteip/realip) dan `peer=` (IP gerbang). Contoh yang diharapkan: client dari Alpha `192.217.4.2`, dari Delta `192.217.5.2`; peer `192.217.3.2` pada vault dan `192.217.2.2` pada core.


**CONSOLE ALPHA.**

```bash
hostname
for i in $(seq 1 6); do
    curl --noproxy '*' --max-time 10 -sS -o /dev/null "http://www.k12.com/?demo=14-alpha-$i"
    curl --noproxy '*' --max-time 10 -sS -o /dev/null "http://static.k12.com/profil?demo=14-alpha-$i"
done
```

**CONSOLE DELTA.**

```bash
hostname
for i in $(seq 1 6); do
    curl --noproxy '*' --max-time 10 -sS -o /dev/null "http://www.k12.com/?demo=14-delta-$i"
    curl --noproxy '*' --max-time 10 -sS -o /dev/null "http://static.k12.com/profil?demo=14-delta-$i"
done
```

**CONSOLE OBLADI, LALU ULANGI DI DESMOND.**

```bash
hostname
grep 'demo=14-' /var/log/apache2/vault-access.log | tail -n 16
```

**CONSOLE OBLADA, LALU ULANGI DI MOLLY.**

```bash
hostname
grep 'demo=14-' /var/log/nginx/core-access.log | tail -n 16
```

**Target hasil:** Pada log, client dari Alpha harus 192.217.4.2 dan dari Delta 192.217.5.2. Peer tetap IP proxy: Penny untuk vault, Abbey untuk core. Host harus WWW atau static sesuai jalur akses.


## Soal 15
### Jalur /eternal (PHP) di Penny dan /orion (Statis) di Abbey

**Soal:** Penny: reverse proxy path `/eternal` yang menyajikan `/var/www/eternal` dan dapat merender PHP. Abbey: path `/orion` menyajikan `/var/www/orion` murni statis tanpa rendering PHP.

**Script:**

- [`script/11-penny.sh`](script/11-penny.sh) - Backend loopback `127.0.0.1:8080` + PHP-FPM, `ProxyPass /eternal/`.
- [`script/11-abbey.sh`](script/11-abbey.sh) - `location /orion/` dengan `alias`; `.php` ditolak 403.

**Cara menjalankan:**

Sudah termasuk 11-penny.sh dan 11-abbey.sh:

```bash
# tidak ada langkah tambahan
```

**Penjelasan:** Di Penny, `/eternal/` di-proxy ke VirtualHost internal `127.0.0.1:8080` yang menjalankan PHP lewat `SetHandler "proxy:unix:/run/php/php8.4-fpm.sock|fcgi://localhost/"`. Di Abbey, `/orion/` hanya `alias` ke direktori statis, dan permintaan `.php` dijawab `403`.


**CONSOLE ALPHA.**

```bash
echo 'ETERNAL PHP:'
curl --noproxy '*' --max-time 10 -sS -i http://www.k12.com/eternal/
curl --noproxy '*' --max-time 10 -sS -i http://www.k12.com/eternal/index.php
echo 'ORION STATIS:'
curl --noproxy '*' --max-time 10 -sS -i http://static.k12.com/orion/
echo 'PHP PADA ORION DITOLAK:'
curl --noproxy '*' --max-time 10 -sS -D - -o /dev/null http://static.k12.com/orion/contoh.php
```

**CONSOLE PENNY.**

```bash
hostname
ss -lntp | grep ':8080'
ls -l /var/www/eternal
grep -nE 'eternal|8080|SetHandler|DocumentRoot' /etc/apache2/sites-available/penny.conf
```

**CONSOLE ABBEY.**

```bash
hostname
ls -l /var/www/orion
grep -n -A 12 'location /orion/' /etc/nginx/sites-available/abbey.conf
```

**Target hasil:** Eternal menampilkan hasil perhitungan PHP 5; Orion menampilkan HTML statis. Konfigurasi Orion menolak permintaan .php dengan 403.



## Soal 16
### Stress Test ApacheBench (250 request, concurrency 10)

**Soal:** Dari salah satu klien (Alpha), lakukan 250 request dengan concurrency 10 untuk `www.k12.com` dan `static.k12.com`, lalu tampilkan rangkuman hasilnya.

**Script:**

- [`script/16-benchmark.sh`](script/16-benchmark.sh) - Memastikan kedua endpoint HTTP 200, lalu `ab -l -n 250 -c 10`, menyimpan hasil di `/root/bukti-demo`.

**Cara menjalankan:**

Di alpha:

```bash
bash /root/16-benchmark.sh
```

**Penjelasan:** Opsi `-n 250` = jumlah request, `-c 10` = concurrency, `-l` mengizinkan panjang body berbeda antarbackend. Hasil yang diharapkan: `Complete requests: 250`, `Failed requests: 0`, tanpa `Non-2xx responses`.


**CONSOLE ALPHA.**

```bash
bash <<'K12_BENCHMARK'
set -euo pipefail
mkdir -p /root/bukti-demo
for host in www.k12.com static.k12.com; do
    status=$(curl --noproxy '*' --max-time 10 -sS -o /dev/null -w '%{http_code}' "http://$host/")
    printf '%s: HTTP %s\n' "$host" "$status"
    if [ "$status" != 200 ]; then
        echo 'Berhenti: perbaiki endpoint sebelum benchmark.'
        exit 1
    fi
done
ab -l -n 250 -c 10 http://www.k12.com/ 2>&1 | tee /root/bukti-demo/16-ab-www.txt
ab -l -n 250 -c 10 http://static.k12.com/ 2>&1 | tee /root/bukti-demo/16-ab-static.txt
K12_BENCHMARK
```

**CONSOLE ALPHA.**

```bash
for layanan in www static; do
    printf '\nRINGKASAN %s\n' "$layanan"
    grep -E '^(Concurrency Level|Time taken for tests|Complete requests|Failed requests|Non-2xx responses|Requests per second|Time per request|Transfer rate):' "/root/bukti-demo/16-ab-$layanan.txt"
done
```

**Target hasil:** Concurrency Level 10, Complete requests 250, Failed requests 0, tanpa respons non-2xx. -l mengizinkan panjang body berbeda antarbackend. Angka waktu/throughput diambil dari output aktual.



## Soal 17
### TXT Record Klien

**Soal:** Tambahkan TXT record untuk alpha, beta, gamma, delta, epsilon sehingga query TXT mengembalikan nama hostname masing-masing.

**Script:**

- [`script/dns-edit.py`](script/dns-edit.py) - Utilitas edit zona (aksi `txt`, `ttl15`, `fake`, `restore`, `outbound`) yang selalu menaikkan serial SOA.

**Cara menjalankan:**

Di prab:

```bash
python3 /root/dns-edit.py txt
```

**Penjelasan:** Skrip menambah baris `alpha IN TXT "alpha"` dan seterusnya, memvalidasi dengan `named-checkzone`, menaikkan serial SOA, lalu `rndc reload` dan `rndc notify` agar tedd ikut tersinkron.


**CONSOLE ALPHA.**

```bash
for dns in 192.217.1.2 192.217.1.3; do
    printf '\nDNS %s\n' "$dns"
    for host in alpha beta gamma delta epsilon; do
        printf '%s: ' "$host"
        dig @"$dns" "$host.k12.com" TXT +short
    done
done
```

**Target hasil:** TXT domain alpha, beta, gamma, delta, epsilon berisi nama masing-masing. Perubahan zona menaikkan serial dan mengirim notify ke Tedd.



## Soal 18
### TTL 15 Detik dan Perubahan IP Fiktif Abbey

**Soal:** Ubah A record `abbey.k12.com` ke IP fiktif, naikkan serial SOA dan pastikan tedd tersinkron, set TTL 15 detik. Buktikan tiga fase: sebelum perubahan (IP lama), saat jeda TTL (masih IP lama karena cache), setelah TTL habis (IP fiktif).

**Script:**

- [`script/18-cache.sh`](script/18-cache.sh) - Resolver cache sementara (dnsmasq) di alpha pada `127.0.0.1:5300` untuk mengamati TTL.
- [`script/dns-edit.py`](script/dns-edit.py) - Aksi `ttl15`, `fake` (203.0.113.77), dan `restore`.

**Cara menjalankan:**

Di alpha:

```bash
bash /root/18-cache.sh setup
```

Di prab (IP normal dengan TTL 15):

```bash
python3 /root/dns-edit.py ttl15
```

**Penjelasan:** Alpha memakai cache lokal agar efek TTL terlihat; query langsung ke prab selalu menunjukkan data terbaru. Urutan demo: (1) jalankan `reset` lalu `watch` di alpha, (2) sekitar detik ke-3 jalankan `fake` di prab, (3) amati cache alpha tetap IP lama dengan TTL menurun lalu berganti ke `203.0.113.77` setelah TTL habis, (4) `restore` di prab. IP `203.0.113.77` adalah alamat yang valid secara format dan tidak dipakai di jaringan lab.



**Console Alpha.** Buka juga console Prab; jalankan perubahan IP pada Prab sekitar detik ke-3 saat pengamatan Alpha berlangsung.

```bash
bash /root/18-cache.sh reset
bash /root/18-cache.sh watch
```

**Console Prab - saat pengamatan Alpha masih berjalan.**

```bash
python3 /root/dns-edit.py fake
```

**Console Alpha - setelah pengamatan selesai.**

```bash
mkdir -p /root/bukti-demo
cp /root/bukti/ttl-abbey.txt /root/bukti-demo/18-cache.txt
{
    dig @192.217.1.2 k12.com SOA +short
    dig @192.217.1.3 k12.com SOA +short
    dig @192.217.1.3 abbey.k12.com A +norecurse +noall +comments +answer
} 2>&1 | tee /root/bukti-demo/18-tedd-ip-fiktif.txt
```

| Fase | Cache Alpha | Prab authoritative |
|---|---|---|
| Sebelum perubahan | 192.217.2.2 | 192.217.2.2 |
| Record berubah, cache belum kedaluwarsa | 192.217.2.2 dengan TTL menurun | 203.0.113.77 |
| TTL cache habis | 203.0.113.77 | 203.0.113.77 |

**Pemulihan - console Prab.**

```bash
python3 /root/dns-edit.py restore
dig @192.217.1.2 k12.com SOA +short
dig @192.217.1.3 k12.com SOA +short
```

**Check pemulihan - console Alpha.**

```bash
bash /root/18-cache.sh stop
mkdir -p /root/bukti-demo
{
    dig @192.217.1.2 abbey.k12.com A +short
    dig @192.217.1.3 abbey.k12.com A +short
    curl --noproxy '*' --max-time 10 -sS -I http://static.k12.com/
} 2>&1 | tee /root/bukti-demo/18-pemulihan.txt
```

**Target hasil:** TTL dihitung sejak cache diisi. Query langsung ke authoritative tidak menunjukkan fase cache lama. Setelah pengujian, Prab/Tedd harus kembali menjawab 192.217.2.2 dan static kembali HTTP 200.



## Soal 19
### CNAME Eksternal outbound.k12.com ke http.badssl.com

**Soal:** Buat CNAME `outbound.k12.com` ke `http.badssl.com`. Lakukan `curl http://outbound.k12.com` dan pastikan output sesuai dengan isi halaman `http.badssl.com`.

**Script:**

- [`script/dns-edit.py`](script/dns-edit.py) - Aksi `outbound` menghapus record bentrok dan menambah `outbound IN CNAME http.badssl.com.`.

**Cara menjalankan:**

Di prab:

```bash
python3 /root/dns-edit.py outbound
```

**Penjelasan:** CNAME hanya mengalihkan resolusi DNS, bukan header HTTP `Host`. Karena itu perbandingan isi konten dilakukan dengan `-H "Host: http.badssl.com"`, lalu `cmp` memastikan body sama dengan akses langsung ke `http://http.badssl.com/`.


**CONSOLE ALPHA.**

```bash
dig @192.217.1.2 outbound.k12.com CNAME +short
dig @192.217.1.3 outbound.k12.com CNAME +short
dig outbound.k12.com A +noall +comments +answer
curl --noproxy '*' --max-time 20 -sS -i http://outbound.k12.com/
```

**CONSOLE ALPHA.**

```bash
bash <<'K12_OUTBOUND'
set -euo pipefail
mkdir -p /root/bukti-demo
curl --noproxy '*' --max-time 20 -fsS -H 'Host: http.badssl.com' \
    -D /root/bukti-demo/19-outbound.headers \
    http://outbound.k12.com/ -o /root/bukti-demo/19-outbound.html
curl --noproxy '*' --max-time 20 -fsS \
    -D /root/bukti-demo/19-target.headers \
    http://http.badssl.com/ -o /root/bukti-demo/19-target.html
{
    cat /root/bukti-demo/19-outbound.headers
    cat /root/bukti-demo/19-target.headers
    if cmp -s /root/bukti-demo/19-outbound.html /root/bukti-demo/19-target.html; then
        echo 'BODY KEDUA RESPONS SAMA.'
    else
        echo 'BODY BERBEDA: periksa diff dan respons eksternal.'
        diff -u /root/bukti-demo/19-target.html /root/bukti-demo/19-outbound.html || true
    fi
    sed -n '1,25p' /root/bukti-demo/19-outbound.html
} | tee /root/bukti-demo/19-perbandingan.txt
K12_OUTBOUND
```

**Target hasil:** Target DNS: outbound.k12.com CNAME ke http.badssl.com. CNAME tidak mengganti HTTP Host; perbandingan konten memakai Host: http.badssl.com secara eksplisit. Kedua body harus sama sesuai hasil cmp.



## Soal 20
### Autostart dan Pengecekan Setelah Restart

**Soal:** Pastikan semua service dan konfigurasi tetap berjalan dan autostart setelah node di-restart (abaikan konfigurasi nomor 18; kembalikan ke normal).

**Script:**

- [`script/20-autostart.sh`](script/20-autostart.sh) - Membuat `boot.sh`, snapshot konfigurasi, dan cache paket lengkap beserta dependensinya.
- [`script/20-snapshot-dns.sh`](script/20-snapshot-dns.sh) - Memperbarui snapshot di prab/tedd setelah demo DNS.
- [`script/start-command.txt`](script/start-command.txt) - Isi kolom Start command GNS3.

**Cara menjalankan:**

Di prab: pastikan abbey sudah normal:

```bash
python3 /root/dns-edit.py restore
```

Di semua 14 node:

```bash
bash /root/20-autostart.sh
```

Di prab, lalu tedd:

```bash
bash /root/20-snapshot-dns.sh
```

GNS3: isi Start command pada setiap node (Configure/Edit node, lalu Stop dan Start):

```bash
/bin/bash -c '/bin/bash /root/boot.sh || tail -n 60 /root/lab-boot.log; exec /bin/bash'
```

**Penjelasan:** Container GNS3 dapat kehilangan paket dan konfigurasi di layer non-volume saat stop/start, sementara `/root` bersifat persisten. Karena itu `20-autostart.sh` menyimpan paket `.deb` dan snapshot `/etc` penting ke `/root/lab-state`. Saat node start, `boot.sh` (dijalankan oleh Start command) memasang paket dari cache lokal, memulihkan konfigurasi, menerapkan jaringan, menyalakan service sesuai peran, dan mengatur resolver akhir. Log tersimpan di `/root/lab-boot.log`.

**Sebelum restart - semua node.**

```bash
date -Is
hostname
ls -l /root/boot.sh /root/lab-role /root/lab-state/config.tar.gz
tail -n 5 /root/lab-boot.log 2>/dev/null || true
```

**GNS3:** lakukan **Stop lalu Start**. Urutan start: Rootkit -> Prab/Tedd -> empat backend -> Penny/Abbey -> lima klien. Setelah start, langsung jalankan check berikut tanpa menyalakan service secara manual.

**SEMUA 14 NODE SETELAH STOP/START.**

```bash
date -Is
hostname
ip -br -4 address
ip -4 route
cat /etc/resolv.conf
tail -n 20 /root/lab-boot.log
```

**CONSOLE ROOTKIT.**

```bash
sysctl net.ipv4.ip_forward
iptables -t nat -S POSTROUTING
iptables -S FORWARD
```

**CONSOLE PRAB, LALU ULANGI DI TEDD.**

```bash
hostname
pgrep -a named
rndc status
ss -lntup | grep ':53'
```

**PENNY, OBLADI, DESMOND, SATU PER SATU.**

```bash
hostname
apache2ctl configtest
pgrep -a apache2
ss -lntp | grep ':80'
```

**ABBEY, OBLADA, MOLLY, SATU PER SATU.**

```bash
hostname
nginx -t
pgrep -a nginx
ss -lntp | grep ':80'
```

**PENNY, OBLADA, MOLLY, SATU PER SATU.**

```bash
hostname
php-fpm8.4 -t
ps -eo pid,args | grep '[p]hp-fpm: master process'
ls -l /run/php/php8.4-fpm.sock
```

**CONSOLE ALPHA SETELAH SEMUA NODE START.**

```bash
date -Is
hostname
ping -c 3 -W 2 1.1.1.1
dig @192.217.1.2 k12.com SOA +short
dig @192.217.1.3 k12.com SOA +short
dig @192.217.1.2 abbey.k12.com A +short
dig @192.217.1.3 abbey.k12.com A +short
dig @192.217.1.3 -x 192.217.1.4 +norecurse +noall +comments +answer
dig alpha.k12.com TXT +short
dig outbound.k12.com CNAME +short
for url in http://www.k12.com/ http://static.k12.com/ http://www.k12.com/arsip/ http://static.k12.com/profil http://www.k12.com/eternal/ http://static.k12.com/orion/; do
    curl --noproxy '*' --max-time 10 -sS -o /dev/null -w "$url HTTP %{http_code}\n" "$url"
done
curl --noproxy '*' --max-time 10 -sS -o /dev/null -w 'ADMIN TANPA AUTH: %{http_code}\n' http://www.k12.com/admin/
curl --noproxy '*' --max-time 10 -sS -o /dev/null -w 'ADMIN AUTH BENAR: %{http_code}\n' -u 'prabs:pakar_pinter_jadi_gob***' http://www.k12.com/admin/
curl --noproxy '*' --max-time 10 -sS -I http://penny.k12.com/
curl --noproxy '*' --max-time 10 -sS -I http://abbey.k12.com/
```

**Target hasil:** BOOT OK memiliki waktu sesudah restart, proses/port aktif, NAT dan DNS normal, URL normal 200, admin 401/200 sesuai kredensial, redirect 301/302. Ulangi check nomor 11 dan 14 untuk distribusi dan log setelah restart.



