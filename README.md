# Ingressa

Aplikasi mobile Flutter untuk pemesanan tiket dan manajemen event, terintegrasi dengan Firebase (Firestore & Auth) dan ImageKit. Dirancang dengan clean architecture, scalable, dan maintainable.

---

## ✨ Fitur Utama

- Autentikasi (Email/Password & Google Sign-In)
- CRUD user, venues, events, bookings
- Booking tiket real-time
- Upload & optimasi gambar event (ImageKit)
- Role-based access (user, organizer, admin)
- Notifikasi in-app sederhana
- Profile user (nama, email, role, gambar default)

## 🏗️ Arsitektur

- Clean Architecture (presentation, domain, data, core)
- State management: BLoC
- Firebase Firestore & Auth
- ImageKit CDN

## 📦 Dependensi Utama

- flutter_bloc
- firebase_core, firebase_auth, cloud_firestore
- google_sign_in
- get_it
- image_picker
- http

## 🚀 Langkah Instalasi & Setup

1. **Clone repository**
   ```bash
   git clone https://github.com/riofach/event-booking-ingressa.git
   cd name-folder
   ```
2. **Install dependencies**
   ```bash
   flutter pub get
   ```
3. **Setup Firebase** (tanyakan admin)
   - Buat project di [Firebase Console](https://console.firebase.google.com/)
   - Aktifkan Authentication (Email/Password & Google)
   - Buat Firestore Database
   - Download `google-services.json` dan letakkan di `android/app/`
   - (Opsional) Setup SHA-1/SHA-256 untuk Google Sign-In
4. **Konfigurasi ImageKit**
   - Daftar di [ImageKit.io](https://imagekit.io/)
   - Simpan API key & endpoint (akan digunakan di backend/client)
5. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

## 🗂️ Struktur Folder di lib/

- **core/**: utilitas global, constants, themes, error handling, helper
- **data/**: model, data source (API/Firebase/local), repository impl, mapper
- **domain/**: entity utama, abstraksi repository, usecase
- **presentation/**: halaman (pages), widgets, BLoC/cubit/provider, routes

### Contoh Subfolder:

- `data/datasources/` : komunikasi ke API/Firebase/local storage
- `data/repositories/` : implementasi repository
- `domain/entities/` : entity utama aplikasi
- `domain/usecases/` : business logic (misal: login, register, dsb)
- `presentation/pages/` : halaman utama aplikasi (login, register, home, dsb)
- `presentation/bloc/` : state management (BLoC/cubit per fitur)
- `presentation/widgets/` : widget reusable

## 🤝 Tips Kolaborasi

- Ikuti struktur folder dan arsitektur yang sudah ada
- Setiap fitur baru: buat branch baru, pull request, review sebelum merge
- Dokumentasikan logic penting di kode dan README
- Cek list task di `list-be.md` untuk progress dan prioritas

---

Untuk pertanyaan atau kendala, silakan diskusi di grup/tim. Selamat berkontribusi di Ingressa! 🚀
