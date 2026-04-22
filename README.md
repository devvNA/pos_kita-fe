# POS Kita🚀

**POS Kita** adalah aplikasi Point of Sale (Kasir) modern berbasis Flutter yang dirancang khusus untuk UMKM di Indonesia. Aplikasi ini mengutamakan kecepatan transaksi dengan arsitektur **Offline-First**, memastikan operasional bisnis tetap berjalan lancar meski tanpa koneksi internet.

---

## 🛠 Tech Stack & Architecture

Aplikasi ini dibangun dengan standar engineering tinggi untuk memastikan skalabilitas dan kemudahan pemeliharaan:

- **Framework:** Flutter (Dart 3.11+)
- **State Management:** BLoC (Business Logic Component) dengan **Freezed** untuk _immutable state_.
- **Persistence (Offline-First):** SQLite (**sqflite**) untuk database lokal utama dan **SharedPreferences** untuk sesi pengguna.
- **Networking:** REST API integration dengan pola fungsional menggunakan **Dartz** (`Either<String, T>`).
- **Hardware Integration:** Mendukung Thermal Bluetooth Printer dan Barcode/QR Scanning.
- **Design System:** Custom premium design system (Material 3) untuk pengalaman pengguna yang intuitif dan profesional.

---

## ✨ Fitur Utama

- ✅ **Offline-First Architecture:** Transaksi dapat dilakukan secara offline dan otomatis tersinkronisasi ke server saat internet kembali aktif.
- ✅ **Manajemen Stok Real-time:** Kontrol inventaris produk antar outlet dengan mudah.
- ✅ **Laporan Penjualan Otomatis:** Rekapitulasi transaksi harian dan bulanan yang rapi.
- ✅ **Multi-Outlet Support:** Kelola banyak cabang toko dalam satu akun dashboard.
- ✅ **Cetak Struk Bluetooth:** Integrasi langsung dengan printer thermal untuk cetak invoice instan.

---

## 🚀 Cara Menjalankan Project

Pastikan Anda memiliki Flutter SDK yang sesuai sebelum memulai.

1.  **Clone Project:**

    ```bash
    git clone https://github.com/username/flutter-pos-kita.git
    ```

2.  **Instal Dependensi:**

    ```bash
    flutter pub get
    ```

3.  **Generate Code (Freezed/JSON Serializable):**

    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Jalankan Aplikasi:**
    ```bash
    flutter run
    ```

---

## 📁 Struktur Folder Utama

- `lib/core/`: Berisi konstanta global, utilitas, dan komponen _Design System_.
- `lib/data/`: Lapisan data (Models & DataSources) untuk komunikasi API dan database lokal.
- `lib/presentation/`: Lapisan UI yang terorganisir per-fitur (Auth, Home, Transaction, dll).

---

Developed with ❤️
