# Aplikasi Ticketing (POS Tiket Wisata)

Sistem Point of Sale (POS) untuk penjualan tiket wisata. Proyek ini terdiri dari dua bagian:

| Bagian | Teknologi | Folder | Deskripsi |
|--------|-----------|--------|-----------|
| Frontend | Flutter (Dart) | `ticketingapp/` | Aplikasi kasir Android: login, penjualan tiket, pembayaran, cetak struk Bluetooth, scan QR |
| Backend | Laravel 12 (PHP) | `ticketingLaravel/` | REST API: autentikasi, produk, kategori, order, order item |

Frontend berkomunikasi dengan backend melalui REST API JSON dengan autentikasi token (Laravel Sanctum).

---

## Daftar Isi

- [Arsitektur Sistem](#arsitektur-sistem)
- [Alur Kerja Aplikasi](#alur-kerja-aplikasi)
- [Fitur Utama](#fitur-utama)
- [Tech Stack](#tech-stack)
- [Prasyarat](#prasyarat)
- [Setup Backend (Laravel)](#setup-backend-laravel)
- [Setup Frontend (Flutter)](#setup-frontend-flutter)
- [API Reference](#api-reference)
- [Skema Database](#skema-database)
- [Akun Default](#akun-default)
- [Struktur Folder](#struktur-folder)
- [Troubleshooting](#troubleshooting)

---

## Arsitektur Sistem

```
┌─────────────────────────┐        HTTP / JSON        ┌──────────────────────────┐
│   Flutter App (Android) │  ───────────────────────► │   Laravel REST API       │
│   - BLoC state mgmt     │   Authorization: Bearer   │   - Sanctum token auth   │
│   - SQLite (offline)    │  ◄─────────────────────── │   - Eloquent ORM         │
│   - Bluetooth printer   │        JSON response      │   - MySQL / SQLite DB    │
└─────────────────────────┘                           └──────────────────────────┘
        │
        └──► Printer Thermal Bluetooth (POS58B) — cetak struk ESC/POS
```

- **Offline-first:** order selalu disimpan dulu ke SQLite lokal (`is_sync = 0`), lalu disinkronkan ke server saat online.
- **Autentikasi:** login menghasilkan token Sanctum yang disimpan di SharedPreferences dan dikirim sebagai Bearer token pada setiap request.
- **Repository layer:** tidak ada. BLoC mengakses datasource (remote/local) secara langsung.

---

## Alur Kerja Aplikasi

1. **Splash Screen** — memeriksa status login dari SharedPreferences.
2. **Login** — pengguna memasukkan email & password, token disimpan.
3. **Halaman Order (Penjualan)** — daftar tiket, pencarian, filter kategori, tombol favorit.
4. **Keranjang / Order Detail** — memilih metode pembayaran (QRIS / Tunai / Transfer).
5. **Pembayaran**
   - **Tunai:** input nominal → order disimpan lokal → halaman sukses.
   - **QRIS:** menampilkan QR dinamis dengan countdown 60 detik.
6. **Payment Success** — menampilkan struk + QR transaksi dan tombol cetak via Bluetooth.
7. **Sinkronisasi** — order yang belum tersinkron dikirim ke backend via menu Setting.

---

## Fitur Utama

### Frontend (Flutter)
- Autentikasi (login / logout) dengan penyimpanan token lokal.
- Manajemen produk/tiket: tambah, edit, hapus, sinkronisasi kategori & produk.
- Point of Sale: daftar produk, pencarian, filter kategori, favorit (like).
- Keranjang belanja dan checkout dengan kalkulasi total.
- Metode pembayaran: **QRIS** (QR + countdown), **Tunai**, **Transfer**.
- Riwayat transaksi dikelompokkan per bulan/tahun.
- Cetak struk thermal Bluetooth (ESC/POS, ukuran 58mm, printer POS58B).
- Scan QR dengan kamera (`mobile_scanner`).
- Generate QR code (`qr_flutter`).
- Edit profil + upload foto profil (kamera/galeri).
- Penyimpanan lokal SQLite untuk produk, kategori, order, dan order item.
- Deteksi koneksi internet (`connectivity_plus`) untuk sinkronisasi.

### Backend (Laravel)
- REST API dengan Laravel Sanctum (token-based auth).
- CRUD Produk (dengan relasi kategori).
- CRUD Kategori (sebagian masih stub).
- Pembuatan Order beserta order item (`createMany`).
- Seeder untuk user, kategori, dan produk contoh.

---

## Tech Stack

### Frontend
| Library | Versi | Fungsi |
|---------|-------|--------|
| Flutter / Dart SDK | `^3.6.0` | Framework aplikasi |
| flutter_bloc | `^9.0.0` | Manajemen state (BLoC) |
| freezed / freezed_annotation | `^2.5.8` | Generasi event & state (immutable) |
| bloc | `^9.1.0` | Inti BLoC |
| dartz | `^0.10.1` | Functional error handling (`Either`) |
| go_router | `^14.8.0` | Routing (dideklarasikan, belum dipakai) |
| sqflite | `^2.4.1` | Database SQLite lokal |
| shared_preferences | `^2.5.2` | Penyimpanan token/user |
| http | `1.3.0` (transitif) | HTTP client |
| print_bluetooth_thermal | `^1.1.6` | Cetak via Bluetooth thermal |
| esc_pos_utils_plus | `^2.0.4` | Generator perintah ESC/POS |
| mobile_scanner | `^6.0.6` | Scan QR via kamera |
| qr_flutter | `^4.1.0` | Generate QR code |
| image_picker | `^1.1.2` | Pilih gambar dari kamera/galeri |
| connectivity_plus | `^6.1.3` | Cek status koneksi |
| permission_handler | `^12.0.0+1` | Izin runtime (Bluetooth, lokasi) |
| flutter_spinkit | `^5.2.1` | Loading indicator |
| flutter_svg | `^2.0.17` | Render ikon SVG |
| intl | `^0.20.2` | Format tanggal & mata uang |
| timer_count_down | `^2.2.2` | Countdown pembayaran QRIS |
| google_fonts / url_launcher | — | Dideklarasikan, belum dipakai |
| flutter_gen / flutter_gen_runner | `^5.9.0` | Akses asset bertipe |
| build_runner | `^2.4.15` | Code generation |

### Backend
| Komponen | Versi |
|----------|-------|
| PHP | `^8.2` |
| Laravel Framework | `^12.0` (terpasang v12.56.0) |
| Laravel Sanctum | `^4.0` (terpasang v4.3.1) |
| Laravel Tinker | `^2.10.1` |
| PHPUnit | `^11.5.3` |
| Vite / Tailwind CSS | 6 / 4 |

---

## Prasyarat

- **PHP** >= 8.2 dan **Composer**
- **MySQL** (atau SQLite) sebagai database
- **Node.js & npm** (opsional, hanya untuk aset frontend Laravel)
- **Flutter SDK** (stable, Dart `^3.6.0`)
- **Perangkat Android fisik** (Bluetooth & kamera tidak berfungsi di emulator)

---

## Setup Backend (Laravel)

```bash
# 1. Masuk ke folder backend
cd ticketingLaravel

# 2. Install dependency PHP
composer install

# 3. Salin file environment & generate app key
cp .env.example .env
php artisan key:generate

# 4. Konfigurasi database di .env
#    Opsi MySQL:
#      DB_CONNECTION=mysql
#      DB_HOST=127.0.0.1
#      DB_PORT=3306
#      DB_DATABASE=ticketingLaravel3
#      DB_USERNAME=root
#      DB_PASSWORD=
#    Opsi SQLite (file database/database.sqlite sudah tersedia):
#      DB_CONNECTION=sqlite

# 5. Migrasi + isi data awal (seeder)
php artisan migrate --seed

# 6. Jalankan server
php artisan serve
```

Server berjalan di `http://127.0.0.1:8000`. Agar dapat diakses perangkat Android pada jaringan yang sama, jalankan dengan host LAN:

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

Jalankan semua service sekaligus (server, queue, log, vite) dengan:

```bash
composer dev
```

> **Catatan:** `.env.example` default memakai SQLite, sedangkan `.env` yang ter-commit memakai MySQL dengan database `ticketingLaravel3`.

---

## Setup Frontend (Flutter)

```bash
# 1. Masuk ke folder frontend
cd ticketingapp

# 2. Install dependency
flutter pub get

# 3. Generate kode Freezed (event/state)
dart run build_runner build --delete-conflicting-outputs

# 4. (Opsional) Generate akses asset bertipe
dart run flutter_gen_runner

# 5. Jalankan aplikasi
flutter run
```

### Konfigurasi Base URL

URL API diatur di `ticketingapp/lib/core/constants/variable.dart`:

```dart
class Variable {
  static const String baseUrl = 'http://192.168.32.65:8000'; // ganti sesuai IP server
  ...
}
```

> **Penting:** ganti `baseUrl` dengan IP LAN mesin yang menjalankan backend Laravel. Perangkat Android dan server harus berada di jaringan yang sama.

### Konfigurasi Printer

- Printer harus **sudah dipasangkan (paired)** melalui pengaturan Bluetooth Android sebelum digunakan.
- Buka menu **Setting → Printer**, pilih perangkat, lalu sambungkan.
- Pastikan izin Bluetooth, Nearby Devices, dan Lokasi telah diberikan.

---

## API Reference

Base URL: `http://<host>:8000/api`

Semua endpoint (kecuali `login` dan `register`) memerlukan header:

```
Authorization: Bearer <token>
Content-Type: application/json
```

> **Catatan:** route didaftarkan sebagai `apiResource` dengan path yang sudah mengandung `api-`, sehingga URL final menjadi `/api/api-product`, `/api/api-categories`, dst.

### Autentikasi

| Method | Endpoint | Deskripsi | Auth |
|--------|----------|-----------|------|
| POST | `/api/login` | Login (`email`, `password`) → `{ user, token }` | Tidak |
| POST | `/api/register` | Registrasi (`name`, `email`, `phone`, `password`, `password_confirmation`) | Tidak |
| POST | `/api/logout` | Hapus token aktif | Ya |
| GET | `/api/user` | Data user yang sedang login | Ya |

### Produk

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/api-product` | Daftar semua produk (dengan kategori) |
| POST | `/api/api-product` | Tambah produk (`name`, `price`, `stock`, `category_id`, `criteria`) |
| GET | `/api/api-product/{name}` | Detail produk berdasarkan **nama** |
| PUT/PATCH | `/api/api-product/{id}` | Update produk (`name`, `price`) |
| DELETE | `/api/api-product/{id}` | Hapus produk |

### Kategori

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/api-categories` | Daftar kategori |
| POST | `/api/api-categories` | Tambah kategori (`name`) |
| GET/PUT/DELETE | `/api/api-categories/{id}` | Belum diimplementasikan (stub) |

### Order

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/api-orders` | Buat order + order items (`order_items` array), status 201 |
| GET/PUT/DELETE | `/api/api-orders` | Belum diimplementasikan (stub) |

### Order Items

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET/POST/PUT/DELETE | `/api/api-orders-items` | Belum diimplementasikan (stub) |

Endpoint tambahan: `GET /api/user` (data user), `GET /up` (health check), `GET /sanctum/csrf-cookie`.

---

## Skema Database

Database utama: `ticketingLaravel3` (MySQL) atau `database/database.sqlite`.

### `users`
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| id | bigint | Primary key |
| name | string | Nama |
| email | string | Unik |
| phone | string | Unik, nullable |
| password | string | Hashed |
| role | enum | `admin` / `user` (default `user`) |
| email_verified_at | timestamp | Nullable |
| timestamps | | |

### `categories`
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| id | bigint | Primary key |
| name | string | Nama kategori |
| description | string | Nullable |

### `products`
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| id | bigint | Primary key |
| name | string | Nama produk/tiket |
| description | string | Nullable |
| price | integer | Harga |
| stock | integer | Stok |
| category_id | FK → categories | `onDelete cascade` |
| status | enum | `draft` / `published` / `archived` (default `published`) |
| criteria | enum | `single` / `grup` (default `single`) |

### `orders`
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| id | bigint | Primary key |
| transaction_time | timestamp | Waktu transaksi |
| total_price | integer | Total harga |
| total_item | integer | Total item |
| payment_amount | integer | Nominal pembayaran |
| payment_method | string | `qris` / `tunai` / `transfer` |
| cashier_id | FK → users | `onDelete cascade` |
| cashier_name | string | Nama kasir |

### `order_items`
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| id | bigint | Primary key |
| order_id | FK → orders | `onDelete cascade` |
| product_id | FK → products | `onDelete cascade` |
| quantity | integer | Jumlah |
| total_price | integer | Subtotal |

Tabel pendukung Laravel: `password_reset_tokens`, `sessions`, `cache`, `cache_locks`, `jobs`, `job_batches`, `failed_jobs`, `personal_access_tokens`.

### Relasi
```
Categories 1 ──< Products 1 ──< OrderItems >── 1 Orders >── 1 User (cashier)
```

### Database Lokal (SQLite Flutter)
File `ticket2.db`, versi 1, tabel: `products`, `category`, `orders`, `order_items`. Kolom `is_sync` pada `orders` menandai order yang sudah/belum tersinkron ke server.

---

## Akun Default

Data hasil seeder (`php artisan migrate --seed`):

| Role | Email | Password |
|------|-------|----------|
| admin | `admin@gmail.com` | `12345678` |
| user | `user@gmail.com` | `12345678` |

**Kategori:** Swim, Zoo (Ragunan), Musik (Enhypen ot6), Snow
**Produk:** Kursus (100000), Waterboom (3500), Jungle Land (1500)

---

## Struktur Folder

### Frontend — `ticketingapp/lib/`
```
lib/
├── main.dart                    # Entry point + DI (MultiBlocProvider)
├── core/                        # Utilitas lintas fitur
│   ├── assets/                  # Asset bertipe (flutter_gen)
│   ├── components/              # Widget reusable (button, textfield, dll)
│   ├── constants/               # Warna (colors.dart) & konfigurasi (variable.dart)
│   └── extensions/              # Extension (context, date, num, string)
├── data/
│   ├── datasource/              # Remote (HTTP) & Local (SQLite/SharedPrefs)
│   ├── model/                   # request/ & response/ model
│   └── outputs/                 # Generator struk ESC/POS
├── presentation/
│   ├── auth/                    # Splash, Login + BLoC login/logout
│   └── home/                    # Halaman utama, BLoC, dialog, widget
└── models/                      # Model dummy (warisan, tidak dipakai)
```

### Backend — `ticketingLaravel/`
```
app/
├── Http/Controllers/Api/        # Auth, Product, Category, Order, OrderItem
├── Models/                      # User, Categories, Products, Order, OrderItem
└── Providers/
routes/api.php                   # Definisi seluruh endpoint API
database/
├── migrations/                  # Skema tabel
├── seeders/                     # UserSeeder, CategoriesSeeder, ProductSeeder
└── factories/
config/                          # Konfigurasi (sanctum.php, database.php, dll)
```

---

## Troubleshooting

| Masalah | Solusi |
|---------|--------|
| Aplikasi tidak bisa terhubung ke server | Ganti `baseUrl` di `variable.dart` sesuai IP LAN server; pastikan satu jaringan |
| Printer tidak terdeteksi | Pair printer lewat pengaturan Bluetooth Android terlebih dahulu, berikan izin lokasi & nearby devices |
| Build release tanpa internet | Tambahkan izin `INTERNET` ke `android/app/src/main/AndroidManifest.xml` (saat ini hanya ada di manifest debug/profile) |
| Error `Data ga ada` saat startup | Token belum tersimpan — lakukan login ulang |
| Error generated Freezed hilang | Jalankan `dart run build_runner build --delete-conflicting-outputs` |
| Test widget default gagal | `test/widget_test.dart` masih berisi smoke test bawaan Flutter, perlu diperbarui |
| Endpoint kategori/order mengembalikan kosong | Beberapa method controller masih berupa stub (belum diimplementasikan) |

---

## Catatan Pengembangan

- **Tanpa role-based access control:** kolom `role` tersimpan di database tetapi tidak diterapkan pada otorisasi.
- **Layer repository belum diterapkan:** BLoC langsung memanggil datasource.
- **Kode warisan:** `lib/models/` dan `lib/gen/assets.gen.dart` berisi kode dummy yang tidak terpakai.
- **Dependency belum dideklarasikan:** `http` dipakai langsung namun hanya tersedia sebagai dependency transitif — sebaiknya ditambahkan eksplisit ke `pubspec.yaml`.
- **Dependency tak terpakai:** `go_router`, `google_fonts`, `url_launcher` dideklarasikan tetapi belum digunakan.
