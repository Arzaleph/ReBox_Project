# ✅ SETUP COMPLETE - ReBox Project

## 🎉 Yang Sudah Dibuat

### 📁 Backend (Laravel - BE/)
- ✅ DemoSeeder dengan data lengkap:
  - 2 demo users (demo@rebox.com, john@example.com)
  - 8 kategori (Elektronik, Pakaian, Buku, Dapur, dll)
  - 7 boxes dengan deskripsi lengkap
  - 23 items dengan relasi ke box dan kategori
- ✅ API Routes sudah configured
- ✅ Controllers sudah ready (Auth, Box, Item, Category)
- ✅ Database migrations ready

### 📱 Frontend (Flutter - ReBox_Project/)
- ✅ API Service dengan exception handling
- ✅ Auth Service (login, register, logout)
- ✅ Box, Item, Category Services (CRUD)
- ✅ Models (User, Box, Item, Category)
- ✅ Login & Register screens dengan validasi
- ✅ Splash screen dengan auto-login
- ✅ Reusable Widgets:
  - LoadingWidget
  - ErrorWidget
  - EmptyWidget
  - SnackBarHelper
- ✅ Validators untuk form validation
- ✅ Connection test screen untuk debugging

### 📄 Documentation
- ✅ README.md - Full documentation
- ✅ QUICK_START.md - Panduan cepat
- ✅ API_CONFIG_GUIDE.md - Konfigurasi API detail
- ✅ AppConfig - Constants & configuration

### 🔧 Scripts (Windows)
- ✅ setup_all.bat - Setup lengkap BE & FE
- ✅ setup_backend.bat - Setup Laravel only
- ✅ setup_frontend.bat - Setup Flutter only
- ✅ start_server.bat - Start Laravel server

---

## 🚀 LANGKAH SELANJUTNYA

### 1. Setup Backend (WAJIB - Hanya Sekali)

Pilih salah satu:

**Opsi A - Automatic (Recommended):**
```bash
cd ReBox_Project
scripts\setup_backend.bat
```

**Opsi B - Manual:**
```bash
cd BE
composer install
copy .env.example .env
php artisan key:generate

# Edit .env untuk database config
# DB_DATABASE=rebox_db
# DB_USERNAME=root
# DB_PASSWORD=

# Buat database di MySQL
# CREATE DATABASE rebox_db;

php artisan migrate:fresh --seed
```

### 2. Setup Frontend (WAJIB - Hanya Sekali)

```bash
cd ReBox_Project
flutter pub get
```

### 3. Jalankan Laravel Server (SETIAP KALI DEV)

**Opsi A - Script:**
```bash
scripts\start_server.bat
```

**Opsi B - Manual:**
```bash
cd BE
php artisan serve --host=10.4.5.19 --port=8000
```

### 4. Konfigurasi Base URL

Edit `lib/core/services/api_service.dart`:

**Untuk Physical Device (HP):**
```dart
static const String baseUrl = 'http://10.4.5.19:8000/api';
```
✅ Sudah dikonfigurasi dengan IP komputer Anda!

**Untuk Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

### 5. Run Flutter App

```bash
flutter run
```

### 6. Login

Gunakan akun demo:
- Email: `demo@rebox.com`
- Password: `password123`

---

## 📊 Data Demo yang Tersedia

### User 1: Demo User (demo@rebox.com)
**5 Boxes:**
1. Box Kamar Tidur (3 items)
   - Jaket Musim Dingin (2 pcs)
   - Selimut Tambahan (3 pcs)
   - Bantal Sofa (5 pcs)

2. Box Dapur (3 items)
   - Mixer Listrik
   - Set Cetakan Kue (12 pcs)
   - Piring Makan Set (6 pcs)

3. Box Ruang Kerja (4 items)
   - Printer HP LaserJet
   - Ream Kertas A4 (3 pcs)
   - Mouse Wireless (2 pcs)
   - Stapler dan Isi

4. Box Garasi (3 items)
   - Raket Badminton (2 pcs)
   - Bola Basket
   - Matras Yoga (2 pcs)

5. Box Anak (3 items)
   - Lego Classic
   - Boneka Teddy Bear (3 pcs)
   - Buku Cerita Anak (15 pcs)

### User 2: John Doe (john@example.com)
**2 Boxes:**
1. Box Koleksi (2 items)
   - Headphone Sony
   - Novel Klasik (20 pcs)

2. Box Gudang (2 items)
   - Kabel Charger (10 pcs)
   - Lampu Hias LED (5 pcs)

### 8 Kategori:
1. Elektronik
2. Pakaian
3. Buku
4. Dapur
5. Mainan
6. Alat Tulis
7. Olahraga
8. Dekorasi

---

## 🧪 Testing & Debugging

### Test Koneksi BE-FE

Buat test screen atau gunakan connection_test_screen.dart:

```dart
import 'package:project_pti/core/screens/connection_test_screen.dart';

// Di main screen, tambahkan button:
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConnectionTestScreen()),
    );
  },
  child: Text('Test Connection'),
)
```

### Test API dengan cURL

```bash
# Test Login
curl -X POST http://10.4.5.19:8000/api/login -H "Content-Type: application/json" -d "{\"email\":\"demo@rebox.com\",\"password\":\"password123\"}"

# Test Get Boxes (ganti TOKEN)
curl -X GET http://10.4.5.19:8000/api/boxes -H "Authorization: Bearer YOUR_TOKEN"
```

### Test dari Browser

Buka di browser HP (pastikan 1 WiFi):
```
http://10.4.5.19:8000
```

Harus muncul halaman Laravel default.

---

## 🔥 Troubleshooting Cepat

### ❌ "Connection refused"
```bash
# 1. Cek Laravel server running
# 2. Test dari browser: http://10.4.5.19:8000
# 3. Cek firewall tidak blokir port 8000
# 4. Pastikan 1 WiFi (untuk HP)
```

### ❌ "Class 'DemoSeeder' not found"
```bash
cd BE
composer dump-autoload
php artisan migrate:fresh --seed
```

### ❌ "SQLSTATE[HY000] [2002]"
```bash
# Start MySQL (XAMPP/WAMP)
# Buat database: rebox_db
```

### ❌ "401 Unauthorized" setelah login
```bash
# Token expired, logout dan login ulang
# Atau clear app data
```

---

## 📱 Platform-Specific Config

| Platform | Base URL |
|----------|----------|
| Android Emulator | `http://10.0.2.2:8000/api` |
| iOS Simulator | `http://127.0.0.1:8000/api` |
| Physical Device | `http://10.4.5.19:8000/api` |

**PENTING:** Ganti di `lib/core/services/api_service.dart` line 8

---

## 📝 Checklist Sebelum Demo

- [ ] MySQL running (XAMPP/WAMP)
- [ ] Database `rebox_db` exists
- [ ] Run `php artisan migrate:fresh --seed`
- [ ] Laravel server running di `10.4.5.19:8000`
- [ ] Base URL di Flutter sudah sesuai platform
- [ ] HP dan laptop dalam 1 WiFi (jika pakai HP)
- [ ] Firewall tidak blokir port 8000
- [ ] Test akses dari browser HP
- [ ] Test login dengan demo@rebox.com

---

## 🎯 Next Steps (Pengembangan Lanjutan)

### Fitur yang Bisa Ditambahkan:

1. **Search & Filter**
   - Cari item by name
   - Filter by category
   - Filter by box

2. **Image Upload**
   - Upload foto box
   - Upload foto item
   - Image gallery

3. **Statistics**
   - Total boxes per user
   - Total items per category
   - Most used categories

4. **QR Code**
   - Generate QR per box
   - Scan QR untuk quick access

5. **Export/Import**
   - Export data ke Excel
   - Import dari CSV
   - Backup & restore

6. **Notifications**
   - Reminder untuk check items
   - Low stock notification
   - Item expiry reminder

7. **Sharing**
   - Share box dengan user lain
   - Collaborative boxes
   - Access control

---

## 📞 Support & Resources

- **Full Docs:** README.md
- **Quick Start:** QUICK_START.md
- **API Config:** API_CONFIG_GUIDE.md
- **Laravel Docs:** https://laravel.com/docs
- **Flutter Docs:** https://flutter.dev/docs

---

## 🏆 Summary

### ✅ Backend Ready:
- Laravel server configured
- Database with demo data
- 4 API controllers (Auth, Box, Item, Category)
- 23 API endpoints

### ✅ Frontend Ready:
- Flutter app configured
- 5 services (API, Auth, Box, Item, Category)
- 4 models (User, Box, Item, Category)
- Complete auth flow
- Reusable widgets & validators

### ✅ Connection:
- IP configured: 10.4.5.19
- Port: 8000
- API endpoint: http://10.4.5.19:8000/api

---

**🚀 You're all set! Happy coding!**

Jika ada masalah, cek dokumentasi atau lihat troubleshooting section.
