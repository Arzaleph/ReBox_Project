# 🚀 QUICK START GUIDE - ReBox

## ⚡ Setup Cepat (Recommended)

### Opsi 1: Automatic Setup (Windows)
```bash
# Jalankan script setup otomatis
scripts\setup_all.bat
```

Script akan otomatis:
- ✅ Install composer dependencies
- ✅ Setup .env file
- ✅ Generate app key
- ✅ Migrate & seed database
- ✅ Install flutter dependencies

### Opsi 2: Manual Setup

#### Backend (Laravel)
```bash
cd BE
composer install
copy .env.example .env
php artisan key:generate
php artisan migrate:fresh --seed
```

#### Frontend (Flutter)
```bash
cd ReBox_Project
flutter pub get
```

---

## 🎯 Jalankan Aplikasi

### 1. Start Laravel Server

**Automatic (Windows):**
```bash
scripts\start_server.bat
```

**Manual:**
```bash
cd BE
php artisan serve --host=10.4.5.19 --port=8000
```

Server berjalan di: `http://10.4.5.19:8000`

### 2. Run Flutter App

**Physical Device (HP):**
```bash
flutter run
```

**Android Emulator:**
1. Ubah baseUrl di `lib/core/services/api_service.dart`:
   ```dart
   static const String baseUrl = 'http://10.0.2.2:8000/api';
   ```
2. Jalankan:
   ```bash
   flutter run
   ```

---

## 🔑 Login Credentials

### Demo User
- Email: `demo@rebox.com`
- Password: `password123`
- Data: 5 boxes, 21 items

### John Doe
- Email: `john@example.com`
- Password: `password123`
- Data: 2 boxes, 2 items

---

## 📝 Checklist Sebelum Testing

- [ ] MySQL/XAMPP running
- [ ] Database `rebox_db` sudah dibuat
- [ ] Sudah run `php artisan migrate:fresh --seed`
- [ ] Laravel server running
- [ ] HP dan laptop dalam 1 WiFi (untuk physical device)
- [ ] Base URL di `api_service.dart` sudah sesuai

---

## 🐛 Quick Troubleshooting

### ❌ "Connection refused"
```bash
# Cek Laravel server masih running
# Cek IP di api_service.dart sudah benar
# Test dari browser HP: http://10.4.5.19:8000
```

### ❌ "Class 'DemoSeeder' not found"
```bash
cd BE
composer dump-autoload
php artisan migrate:fresh --seed
```

### ❌ "SQLSTATE[HY000] [2002]"
```bash
# Start MySQL di XAMPP/WAMP
# Buat database: rebox_db
```

### ❌ HP tidak terdeteksi
```bash
# Enable USB Debugging
# Settings > About > Tap Build Number 7x
# Developer Options > USB Debugging ON

adb devices
```

---

## 📂 Project Structure

```
ReBox_Project/
├── scripts/              # Setup & run scripts
│   ├── setup_all.bat    # Setup lengkap
│   ├── start_server.bat # Start Laravel
│   └── ...
├── lib/
│   ├── auth/            # Login & Register
│   ├── core/
│   │   ├── services/    # API Services
│   │   ├── models/      # Data Models
│   │   ├── widgets/     # Reusable Widgets
│   │   └── utils/       # Validators & Helpers
│   └── main.dart
└── BE/                  # Laravel Backend
    ├── app/
    │   ├── Http/Controllers/Api/
    │   └── Models/
    └── database/seeders/
```

---

## 🎨 Fitur yang Tersedia

### ✅ Authentication
- [x] Login dengan email/password
- [x] Register akun baru
- [x] Auto-login (token storage)
- [x] Logout

### ✅ Core Features
- [x] Manajemen Box (CRUD)
- [x] Manajemen Item (CRUD)
- [x] Kategori Item
- [x] User-specific data

### ✅ UI/UX
- [x] Loading states
- [x] Error handling
- [x] Form validation
- [x] Empty states
- [x] Snackbar notifications

---

## 📚 Documentation

- **README.md** - Full documentation
- **API_CONFIG_GUIDE.md** - API configuration guide
- **lib/core/config/app_config.dart** - App constants

---

## 🔧 Development Tools

### Useful Commands

**Backend:**
```bash
php artisan route:list          # List all routes
php artisan tinker              # Laravel REPL
php artisan migrate:fresh       # Reset database
php artisan db:seed             # Run seeders
```

**Frontend:**
```bash
flutter doctor                  # Check Flutter setup
flutter devices                 # List connected devices
flutter clean                   # Clean build cache
flutter pub get                 # Install dependencies
flutter run --verbose           # Run with logs
```

### Testing API dengan Postman/cURL

**Login:**
```bash
curl -X POST http://10.4.5.19:8000/api/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"demo@rebox.com\",\"password\":\"password123\"}"
```

**Get Boxes:**
```bash
curl -X GET http://10.4.5.19:8000/api/boxes \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 💡 Tips

1. **First Time Setup:** Gunakan `scripts\setup_all.bat`
2. **Development:** Gunakan emulator untuk testing cepat
3. **UI Testing:** Gunakan physical device untuk better UX
4. **Debug:** Enable verbose logging di Flutter
5. **API Testing:** Gunakan Postman untuk test endpoint

---

## 🆘 Need Help?

1. Check **README.md** untuk dokumentasi lengkap
2. Check **API_CONFIG_GUIDE.md** untuk masalah koneksi
3. Check **Troubleshooting** section di README
4. Lihat error logs di terminal

---

**Happy Coding! 🎉**

IP Komputer Anda: `10.4.5.19`
API Endpoint: `http://10.4.5.19:8000/api`
