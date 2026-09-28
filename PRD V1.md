# PRD v2 — Loko Coffee: POS + Accounting & Website Online Order

**Status:** Draft untuk review · **Tujuan dokumen:** acuan pembuatan mockup/prototype klik untuk pitching ke pemilik bisnis **Deadline pitching:** Rabu, 30 September 2026 (malam) **Nama produk:** dummy — brand contoh **Loko Coffee** (2 cabang)

---

## 1. Ringkasan

Loko Coffee adalah sistem terintegrasi untuk bisnis kopi/F&B yang terdiri dari:

1. **Loko POS** — aplikasi kasir (tablet landscape & laptop) dengan 3 tab: **Kasir**, **Pesanan**, **Accounting**.
2. **Loko Order** — website online order (mobile web) dengan alur pesan seperti aplikasi Kopi Kenangan.
3. **Loko Assistant** — chatbot AI di WhatsApp untuk notifikasi, bantuan, dan laporan.

**Pesan utama pitching:** *Moka itu POS. Kita POS + pembukuan otomatis.* Pemilik bisnis nggak perlu paham akuntansi, tapi setiap transaksi langsung jadi jurnal, HPP, laba rugi, dan neraca.

### Diferensiasi vs Moka (inti cerita pitching)

|  | Moka POS | Loko |
| --- | --- | --- |
| Penjualan, stok, loyalty, multi-outlet | Ada | Ada (parity) |
| Laporan keuangan (Laba Rugi, Neraca, Arus Kas) | Tidak ada; hanya laporan penjualan | **Ada, real-time, otomatis** |
| HPP akurat dari pembelian bahan (FIFO/Average) | Terbatas | **Ada** |
| Rekonsiliasi bank & multi-kas | Tidak ada | **Ada** |
| Pajak siap lapor (PPN / PPh Final UMKM) | Tidak ada | **Ada** |
| Asisten WhatsApp AI | Tidak ada | **Ada** |
| Online order milik sendiri (tanpa komisi platform) | Bergantung GoFood/GrabFood | **Ada, web order sendiri** |

---

## 2. Tujuan & Non-tujuan

### Tujuan (untuk mockup)

- Pemilik bisnis paham dalam ±10 menit demo bahwa Loko lebih dari sekadar kasir.
- Semua fitur di brief tampil dan terasa nyata (data dummy realistis, alur bisa diklik).
- Visual rapi, modern, dan konsisten; UX terasa matang (tap sedikit, state jelas, empty/loading/error state ada).
- Tampilkan momen "wow": **bayar di kasir → jurnal otomatis muncul → laba rugi berubah**.

### Non-tujuan (mockup ini)

- Bukan aplikasi fungsional: tidak ada backend, database, payment gateway, atau WhatsApp API sungguhan. Semua data dan aksi disimulasikan.
- Belum mencakup arsitektur teknis final, offline-sync sungguhan, dan integrasi kurir sungguhan.

---

## 3. Pengguna

| Persona | Kebutuhan utama |
| --- | --- |
| **Owner / Pemilik** (target pitching) | Lihat performa 2 cabang, untung-rugi asli, laporan siap pajak, kontrol keamanan; tanpa harus paham akuntansi |
| **Manajer outlet** | Stok, shift, void/refund approval, ringkasan harian |
| **Kasir / Barista** | Transaksi cepat, tidak salah order, struk, tutup shift |
| **Pelanggan online** | Pesan tanpa antre, bayar mudah, tahu status pesanan |

---

## 4. Konteks & Referensi

### 4.1 Fitur Moka POS yang dijadikan acuan (parity)

Hasil riset dari situs resmi, app store, dan review pihak ketiga.

**Kasir & transaksi**

- Multi-payment: tunai, kartu debit/kredit, e-wallet (GoPay, OVO, DANA, LinkAja, dll.), QRIS
- Open bill / simpan tagihan, refund, custom amount (harga bebas)
- Modifier/varian item, catatan item
- Kirim struk via email/SMS/WA; cetak struk, tiket dapur, nomor antrian, rekap shift
- Promo & diskon yang bisa dikustom
- Hardware: printer struk, kitchen printer, barcode scanner, cash drawer, EDC

**Operasional F&B**

- **Table Management**: denah meja custom, status meja berwarna, order per meja
- Dine-in, pick-up, delivery dalam satu sistem
- Order online (GoFood/GrabFood) masuk langsung ke dashboard, tampil bersama order offline
- Mode offline + sinkronisasi otomatis saat online

**Back Office**

- Dashboard & laporan real-time, multi-outlet
- Inventory + **ingredient/resep** (stok bahan terpotong otomatis), alert stok menipis
- **Purchase Order & data supplier**
- Customer database + **loyalty** (poin/diskon)
- **Employee management**: role & akses, jadwal shift
- **Tutup shift** dengan selisih laporan aplikasi vs uang fisik

**Celah Moka yang kita isi:** tidak ada Laba Rugi/Neraca/Arus Kas, tidak ada software akuntansi bawaan, integrasi eksternal terbatas.

### 4.2 Referensi alur Kopi Kenangan (Loko Order)

- Pilih layanan: **Pickup / Dine-in / Delivery**, pilih outlet
- Pesanan bisa diubah sampai dikonfirmasi outlet
- Checkout: metode bayar, **redeem poin (1 poin = Rp1)**, kode voucher, opsi tambah kantong belanja (+Rp1.000)
- **"Jadwalkan"** jam ambil
- Pickup tanpa antre di area khusus
- Poin/reward tiap order, riwayat pesanan, batalkan pesanan

---

## 5. Brand & Desain

- **Brand:** Loko Coffee — hangat, modern, ramah anak muda
- **Warna (usulan, bebas diubah):** hijau botol gelap (primary, kesan kopi premium & "uang/untung"), krem hangat (background), oranye karamel (aksen/CTA), merah untuk error/void, hijau terang untuk sukses
- **Font:** sans-serif modern yang bersih dan mudah dibaca dari jauh (kasir)
- **Prinsip UX:** tombol besar untuk kasir, maksimal 3 tap untuk tambah item + bayar, angka rupiah selalu jelas, status berwarna konsisten, bahasa awam
- **Bahasa UI:** Indonesia; istilah asing yang lebih umum dibiarkan (Dashboard, Shift, Void, Refund, Stock, Voucher, Checkout, dll.)
- **Perangkat:** POS — tablet landscape (utama) & laptop; Order — mobile web

---

## 6. Loko POS

Navigasi: sidebar/tab atas berisi **Kasir · Pesanan · Accounting**, plus **Pengaturan** (ikon, di luar 3 tab utama) untuk user, akses, outlet, dan keamanan. Switcher outlet (Braga / Dago) dan indikator online/offline selalu terlihat.

### 6.1 Tab 1 — Kasir

**Layar utama** (kiri: katalog, kanan: keranjang)

- Kategori + pencarian + grid produk (foto, nama, harga, badge stok menipis/habis)
- Keranjang: item, modifier, catatan, qty, subtotal, diskon, pajak, service (opsional), total
- Tipe order: Dine-in / Takeaway / Delivery; pilihan meja atau nomor antrian
- Pilih pelanggan/member (poin tampil)
- Tombol: **Simpan (Open Bill)**, **Kirim ke Dapur**, **Bayar**

**Fitur yang ditampilkan**

1. Modifier/varian (ukuran, gula, es, extra shot, susu oat)
2. Diskon & promo (persen, nominal, voucher, promo otomatis)
3. Open bill & hold order
4. Split bill & split payment
5. **Table management**: denah meja, status (kosong, terisi, minta bill), pindah/gabung meja
6. **Bayar**: tunai (uang diterima & kembalian), QRIS (QR dummy + status menunggu → berhasil), e-wallet, kartu/EDC, transfer
7. **Struk**: preview struk thermal, cetak, kirim WA/email; tiket dapur; nomor antrian
8. Void & refund (butuh PIN manajer, tercatat di audit log)
9. **Buka & tutup shift**: modal awal, rekap, selisih uang fisik vs sistem
10. Stok real-time: stok terpotong saat bayar (berdasar resep), banner saat bahan kritis
11. Mode offline: banner "Offline — transaksi tersimpan, akan sinkron otomatis" + contoh antrean sync
12. Custom amount (item harga bebas)

**Momen wow #1:** setelah tombol Bayar, muncul toast *"Jurnal otomatis tercatat ✓ — lihat di Accounting"* dengan tautan langsung.

### 6.2 Tab 2 — Pesanan

- Satu daftar semua pesanan, **dipisah per kategori** (tab/filter): **Dine-in · Takeaway/Pickup · Delivery · Online (Web Order)**
- Papan status ala Kanban: **Baru → Diproses → Siap → Diantar/Diambil → Selesai** (+ Dibatalkan)
- Kartu pesanan: nomor, waktu, item, catatan, status bayar, badge sumber (Kasir/Web), timer SLA
- Aksi: terima/tolak pesanan online, ubah status, cetak tiket dapur, hubungi pelanggan via WA
- **Delivery:** pilih kurir (**GoSend / GrabExpress / Lalamove**), estimasi ongkir dan waktu, status kurir (dicari → dijemput → diantar → selesai). Cukup status, tanpa live map.
- Ada mini Kitchen Display: tampilan khusus untuk barista/dapur
- Setiap perubahan status memicu push notif ke pelanggan (lihat §8) dan ditampilkan indikatornya

### 6.3 Tab 3 — Accounting (bintang utama)

Prinsip: **bahasa awam di depan, mode akuntan (jurnal, COA) tersedia di belakang.** Toggle **"Tampilan Sederhana / Mode Akuntan"**.

**a. Dashboard Keuangan (beranda tab)**

- Kartu: Omzet, Laba Kotor, Laba Bersih, Kas Total, Margin %, Hutang Pajak
- Grafik tren pendapatan vs biaya, komposisi biaya, perbandingan Braga vs Dago
- **Insight AI berbahasa awam**, contoh: *"Margin Caramel Macchiato turun 4% minggu ini karena harga susu naik. Pertimbangkan naikkan harga Rp2.000."*
- Filter periode (hari ini, minggu, bulan, custom) dan outlet (gabungan/per cabang)

**b. Auto-Journaling**

- Feed jurnal real-time: tiap transaksi kasir langsung jadi jurnal debit/kredit
- Contoh yang ditampilkan (penjualan Rp100.000 tunai + PPN 11%):
  - Dr Kas Rp111.000 · Cr Penjualan Rp100.000 · Cr Hutang PPN Rp11.000
  - Dr HPP Rp35.000 · Cr Persediaan Rp35.000
- Tampilan awam: kalimat ("Penjualan kopi Rp111.000 masuk ke Kas Laci Braga"); Mode Akuntan: tabel jurnal + COA
- Bisa telusur dari jurnal balik ke transaksi asal

**c. HPP (COGS) Akurat**

- Master bahan baku & resep per menu → HPP per cangkir
- Metode **FIFO / Average** (bisa dipilih), riwayat harga beli per supplier
- Tabel margin per menu, alert menu margin rendah
- Purchase Order & data supplier, penerimaan barang otomatis menambah persediaan dan hutang

**d. Multi-Kas & Rekonsiliasi Bank**

- Pemisahan saldo: **Kas laci per outlet, GoPay, OVO, DANA, QRIS settlement, rekening bank**
- Layar **rekonsiliasi**: kiri catatan Loko, kanan mutasi bank; auto-match berwarna hijau, selisih kuning/merah; tombol "Cocokkan" dan "Tandai selisih"
- Rekonsiliasi shift kasir (selisih uang fisik)

**e. Laporan Keuangan Tiga Pilar**

- **Laba Rugi**, **Neraca**, **Arus Kas** — tampil instan, bisa dibandingkan periode/outlet
- **Ekspor Excel & PDF** (tombol berfungsi sebagai simulasi/unduh contoh)
- Angka harus konsisten antar laporan (Neraca seimbang)

**f. Biaya Operasional (Expense Tracking)**

- Input cepat oleh kasir/owner: kategori (gas, parkir, listrik, gaji harian, sewa, dll.), nominal, foto nota, sumber kas
- Daftar biaya per outlet, langsung memotong laba bersih (terlihat efeknya di dashboard)
- Biaya berulang (sewa, gaji) + pengingat

**g. Pajak Indonesia**

- Perhitungan otomatis **PPN 11%** (dapat diatur) dan **PPh Final UMKM 0,5%** dari omzet
- Halaman **Laporan Siap Pajak**: rekap per bulan, format siap dipindah ke pelaporan, status "Belum bayar / Sudah bayar"
- Pengaturan pajak: PPN / PB1, harga sudah termasuk pajak atau belum
- ⚠️ *Catatan:* restoran/kafe secara umum dikenai **pajak restoran daerah (PB1, biasanya 10%)**, bukan PPN. Mockup menyediakan toggle PPN/PB1 supaya cerita pitching aman. **Verifikasi aturan terbaru dengan konsultan pajak sebelum pitching.**

### 6.4 Pengaturan & Keamanan (ditampilkan ringan)

Klien berlatar SI, jadi ini tampil tapi tidak jadi fokus:

- **Role & akses** (Owner, Manajer, Kasir) dengan matriks izin
- **Audit log** (siapa void, ubah harga, hapus jurnal; kapan, dari perangkat apa)
- Riwayat login/perangkat aktif, PIN manajer, 2FA (tampilan)
- Info keamanan singkat: enkripsi data, backup harian, hak akses database dibatasi per peran
- Semua data tercatat dan siap jadi bahan laporan

### 6.5 Loyalty & Pelanggan (mengikuti Moka; terselip di POS dan Order)

- Database pelanggan (riwayat beli, poin, favorit)
- Program **poin** (tampil "Loko Points"), voucher, tier sederhana
- Dikelola di POS (Pengaturan/Pelanggan), dipakai di Kasir dan Loko Order

---

## 7. Loko Order (Website Online Order)

**Platform:** web mobile-first (PWA). Push notification memakai web push, perlu izin notifikasi.

**Alur layar (mengikuti pola Kopi Kenangan)**

1. **Beranda** — sapaan, banner promo, poin/voucher, menu favorit, tombol pesan
2. **Pilih layanan & outlet** — Pickup / Dine-in / Delivery; pilih **Braga / Dago** (jarak, status buka/tutup); alamat untuk delivery
3. **Menu** — kategori, pencarian, kartu produk, badge (Best Seller, Habis)
4. **Detail produk & customize** — ukuran, gula, es, topping, catatan, qty
5. **Keranjang / konfirmasi pesanan** — ubah/hapus item selama belum dikonfirmasi outlet
6. **Checkout** — voucher, **redeem poin (1 poin = Rp1)**, opsi kantong belanja (+Rp1.000), pilihan waktu (**Sekarang / Jadwalkan**), ringkasan biaya (subtotal, pajak, ongkir, diskon)
7. **Pembayaran** — QRIS, GoPay/e-wallet, Virtual Account (simulasi), status menunggu → berhasil
8. **Tracking pesanan** — stepper status real-time (lihat §8), estimasi waktu, nomor pesanan, tombol batalkan (jika masih boleh), hubungi outlet
9. **Riwayat pesanan** — daftar, detail, "Pesan lagi"
10. **Akun** — profil, poin, voucher, alamat

**Momen wow #2:** pesanan dibuat di web → langsung muncul sebagai kartu "Baru" di tab Pesanan POS.

---

## 8. Notifikasi & Loko Assistant (WhatsApp AI)

### 8.1 Push notif ke pelanggan (setiap step transaksi)

| Status | Contoh pesan |
| --- | --- |
| Pesanan dibuat | "Pesanan #LK-0142 diterima. Menunggu pembayaran ✅" |
| Pembayaran berhasil | "Pembayaran Rp47.000 berhasil. Outlet Braga sedang mengonfirmasi." |
| Dikonfirmasi & diproses | "Barista lagi bikin kopimu ☕" |
| Siap diambil / Kurir dicari | "Pesananmu siap! Ambil di area pickup." |
| Diantar | "Kurir lagi menuju lokasimu." |
| Selesai | "Selamat menikmati! +12 Loko Points masuk." |
| Dibatalkan/refund | "Pesanan dibatalkan. Dana kembali dalam ±1x24 jam." |

Ditampilkan sebagai banner notifikasi simulasi di layar Loko Order.

### 8.2 Loko Assistant (chatbot WhatsApp)

Ditampilkan sebagai layar chat WhatsApp (mockup) dengan **tiga skenario**:

1. **Untuk Owner** — laporan harian otomatis jam 22.00 (omzet, laba, top menu, kas), alert stok kritis, alert selisih shift, tanya bebas ("Kemarin omzet Dago berapa?", "Bulan ini untung berapa?"), pengingat pajak
2. **Untuk Staff/Kasir** — bantuan cepat ("cara void?", "printer tidak nyambung"), pengingat tutup shift, eskalasi ke manusia jika error serius (dukungan **24/7**)
3. **Untuk Pelanggan** — update status pesanan, tanya menu/promo, cek poin, klaim voucher

Prinsip: bahasa ramah dan awam, ada tombol quick-reply, jawaban mengandung angka riil dari data dummy.

---

## 9. Integrasi (tampil sebagai simulasi)

- **Payment gateway** (QRIS, e-wallet, VA): halaman status dan layar QR dummy
- **Kurir instan**: GoSend, GrabExpress, Lalamove (pilihan + status)
- **WhatsApp**: chatbot dan pengiriman struk
- **Perangkat**: printer struk, kitchen printer, cash drawer, scanner (status koneksi di Pengaturan)
- **Dukungan 24/7**: tombol "Bantuan" (chat WA / telepon) di POS

---

## 10. Data Dummy (harus realistis dan konsisten)

**Bisnis:** Loko Coffee, 2 cabang: **Loko Braga** dan **Loko Dago** (Bandung)

**Contoh menu & harga (Rp):** Kopi Susu Loko 22.000 · Americano 20.000 · Cafe Latte 27.000 · Cappuccino 27.000 · Caramel Macchiato 32.000 · Aren Latte 26.000 · Matcha Latte 30.000 · Chocolate 25.000 · Es Teh Lemon 15.000 · Croissant 25.000 · Roti Bakar Coklat 22.000 · Kentang Goreng 20.000 Modifier: Large +5.000 · Extra shot +5.000 · Susu oat +7.000 · Gula (normal/less/no) · Es (normal/less/no)

**Angka operasional (per hari, kisaran):**

- Braga: ±140 transaksi, omzet ±Rp5,9 jt
- Dago: ±115 transaksi, omzet ±Rp4,6 jt
- Rata-rata ±Rp40 rb/transaksi; HPP ±35% dari penjualan
- Sumber bayar: tunai ±35%, QRIS ±45%, e-wallet ±15%, lain ±5%
- Sumber order: kasir/dine-in ±70%, online web ±30%

**Ringkasan bulanan (kisaran, untuk Laba Rugi):**

- Pendapatan ±Rp315 jt · HPP ±Rp110 jt · Laba kotor ±Rp205 jt
- Biaya operasional ±Rp140 jt (gaji, sewa, listrik/air, marketing, lain-lain) → laba bersih ±Rp65 jt
- Neraca harus seimbang (Aset = Kewajiban + Ekuitas)

**Lainnya:** 8–10 karyawan, 12–15 bahan baku, 4–5 supplier, 30–50 pelanggan, 10–20 baris jurnal, 15–25 baris mutasi bank untuk rekonsiliasi (sebagian sengaja selisih), contoh 8–10 pesanan di berbagai status.

---

## 11. Spesifikasi Prototype

- **Format:** HTML statis, tanpa backend, bisa diklik, dibuka di browser
- **Susunan yang direkomendasikan:** **satu file dengan switcher perangkat** (Loko Order di frame HP · Loko POS di frame tablet · WhatsApp di frame HP) supaya presentasi cukup dengan satu link. Alternatif: file terpisah per produk.
- **Interaktivitas minimum:** tambah item ke keranjang, checkout, bayar (simulasi), ganti status pesanan, buka semua tab Accounting, ganti periode/outlet, toggle mode sederhana/akuntan, ekspor (simulasi)
- **Skenario demo yang harus mulus (urutan pitching):**
  1. Pelanggan pesan di Loko Order, bayar QRIS
  2. Pesanan muncul di POS tab Pesanan, dan ada notif ke pelanggan
  3. Barista proses, ubah status, dan pelanggan menerima notif tiap step
  4. Kasir transaksi langsung di POS, cetak struk
  5. Buka Accounting: jurnal otomatis, HPP, dashboard berubah
  6. Laba Rugi / Neraca / Arus Kas, rekonsiliasi bank, pajak
  7. Chat WhatsApp owner: laporan harian dan tanya-jawab
- **Kualitas:** state kosong/loading/error tampil di titik penting; teks tidak terpotong; responsif untuk tablet landscape dan laptop (POS) serta mobile (Order)

---

## 12. Kriteria Selesai (Definition of Done)

- [ ] Semua fitur di §6–§9 dapat ditemukan/ditampilkan dalam prototype
- [ ] 7 langkah skenario demo bisa dijalankan tanpa error
- [ ] Data dummy konsisten (omzet, HPP, laba, neraca, saldo kas cocok antar layar)
- [ ] Bahasa awam di Accounting, istilah akuntan hanya di Mode Akuntan
- [ ] Tampilan rapi di tablet landscape, laptop, dan mobile (Order/WA)
- [ ] Pemilik bisa memahami nilai jual utama tanpa penjelasan panjang

---

## 13. Asumsi, Risiko, dan Hal yang Perlu Dikonfirmasi

**Asumsi yang dipakai (koreksi kalau salah):**

1. Loko Assistant, Loko Order, dan Loko POS berbagi satu data dummy yang sama.
2. Ada "Pengaturan" sebagai area tambahan di luar 3 tab (untuk keamanan, user, printer). Ini bukan tab ke-4.
3. Kurir hanya menampilkan status, tanpa peta live.
4. Warna brand dan nama cabang/lokasi bebas ditentukan tim desain.

**Perlu konfirmasi:**

1. **PPN 11% vs PB1 10%** untuk F&B (lihat catatan §6.3g). Mockup memakai toggle; default mengikuti brief (PPN 11%).
2. **Satu file dengan switcher** atau file terpisah per produk?
3. Persetujuan warna/nuansa brand usulan.

**Risiko:**

- Scope besar untuk deadline 1 hari → prioritaskan **skenario demo** dan layar Accounting; layar pendukung (Pengaturan, loyalty) dibuat lebih ringan.
- Angka dummy tidak konsisten akan merusak kredibilitas → satu sumber data dummy untuk semua layar.
- Klaim "lebih dari Moka" perlu tetap jujur: Moka kuat di ekosistem, hardware, dan integrasi. Fokuskan cerita pada akuntansi otomatis dan WA AI, bukan mengklaim semua lebih unggul.

---

## 14. Prioritas Pengerjaan (deadline besok malam)

| Prioritas | Isi |
| --- | --- |
| **P0 (wajib matang)** | Kasir + bayar + struk · Pesanan (papan status) · Accounting: dashboard, jurnal otomatis, Laba Rugi/Neraca/Arus Kas · Loko Order alur lengkap · WA chat owner |
| **P1 (tampil solid)** | HPP & resep · Multi-kas & rekonsiliasi · Biaya operasional · Pajak · Table management · Push notif · Tutup shift |
| **P2 (tampil ringan)** | Pengaturan & keamanan · Loyalty/pelanggan · Void/refund · Mode offline · Kitchen display · WA staff & pelanggan |

---

### Sumber riset

- Moka: mokapos.com (halaman produk & blog Table Management), Google Play & App Store listing Moka POS, help.mokapos.com, ulasan HashMicro (2026)
- Kopi Kenangan: Google Play listing, Voucherku Help Center, panduan pemesanan pickup/delivery oleh pihak ketiga