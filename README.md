# RBAC Mobile App (Flutter + Firebase)

Aplikasi mobile berbasis Flutter dengan backend Firebase untuk manajemen pemesanan layanan.

🚀 Fitur Saat Ini

✅ Login menggunakan Firebase Authentication

✅ CRUD Pemesanan (Tambah, Edit, Hapus, dan Lihat Daftar Pesanan)

✅ Penyimpanan data menggunakan Cloud Firestore

🔧 Teknologi yang Digunakan

Flutter (Frontend)

Firebase Authentication (Login/Registrasi)

Cloud Firestore (Database Realtime)

📌 Rencana Pengembangan

🔜 Role-Based Access Control (RBAC) untuk mengatur hak akses pengguna

🔜 Pelacakan pemesanan dan laporan

🔜 Notifikasi pemesanan

📥 Instalasi dan Menjalankan Aplikasi

Clone repositori:
```sh
git clone https://github.com/username/reponame.git
cd reponame
```

Install dependencies:
```sh
flutter pub get
```
Jalankan aplikasi:
```sh
flutter run
```
🔑 Konfigurasi Firebase

Buat proyek di [Firebase Console](https://console.firebase.google.com/)

Tambahkan aplikasi Android/iOS ke Firebase.

Unduh file `google-services.json` (untuk Android) atau `GoogleService-Info.plist` (untuk iOS) dan letakkan di folder `android/app` atau `ios/Runner`.

Aktifkan Firebase Authentication dan Cloud Firestore di Firebase Console.

Pastikan izin internet ditambahkan di `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

🛠 Kontribusi

Pull request selalu diterima! Pastikan untuk membuat branch baru sebelum melakukan perubahan.

📄 Lisensi

Proyek ini menggunakan lisensi MIT.

💡 Dibuat dengan Flutter & Firebase untuk mempermudah manajemen pemesanan!
