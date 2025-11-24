# ReBox - Aplikasi Manajemen Box & Item

Aplikasi mobile untuk mengelola box penyimpanan dan item di dalamnya. Dibangun dengan Flutter (Frontend) dan Laravel (Backend).

**Nama Kelompok:**
- Arza Restu Arjuna
- Dimas Faqih Nur Aulia Rohman
- Muhammad Faisal
- Muhammad Favian Rizki
- Surya Bagaskara

## 📋 Daftar Isi
- [Teknologi](#teknologi)
- [Fitur](#fitur)
- [Setup Backend (Laravel)](#setup-backend-laravel)
- [Setup Frontend (Flutter)](#setup-frontend-flutter)
- [Konfigurasi API](#konfigurasi-api)
- [Demo Data](#demo-data)
- [Testing](#testing)

## 🛠 Teknologi

### Backend
- Laravel 11
- Laravel Sanctum (Authentication)
- MySQL Database
- RESTful API

### Frontend
- Flutter 3.9+
- Dart 3.9+
- HTTP Package
- SharedPreferences

## ✨ Fitur

- ✅ Authentication (Login & Register)
- ✅ Manajemen Box (CRUD)
- ✅ Manajemen Item (CRUD)
- ✅ Kategori Item
- ✅ Multi-user support
- ✅ Responsive UI
- ✅ Error handling & validation

## 🚀 Setup Backend (Laravel)

### 1. Prerequisites
Pastikan sudah terinstall:
- PHP 8.2+
- Composer
- MySQL/MariaDB

### 2. Install Dependencies
```bash
cd BE
composer install
```

### 3. Environment Setup
```bash
# Copy .env.example ke .env
copy .env.example .env

# Generate app key
php artisan key:generate
```

### 4. Database Configuration
Edit file `.env`:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=rebox_db
DB_USERNAME=root
DB_PASSWORD=
```

### 5. Create Database
```bash
# Buat database di MySQL
mysql -u root -p
CREATE DATABASE rebox_db;
exit;
```

### 6. Run Migrations & Seeders
```bash
# Migrate database dan jalankan seeder
php artisan migrate:fresh --seed

# Output:
# ✅ Demo data seeded successfully!
# 👤 Demo Users:
#    - demo@rebox.com / password123
#    - john@example.com / password123
# 📦 Created: 7 boxes, 8 categories, 23 items
```

### 7. Run Laravel Server
```bash
# Jalankan server di port 8000
php artisan serve

# Server: http://127.0.0.1:8000
```

### 8. Untuk Testing di HP (Physical Device)
```bash
# Cek IP komputer
ipconfig

# Cari IPv4 Address (contoh: 192.168.1.28)
# Jalankan server dengan IP tersebut:
php artisan serve --host=192.168.1.28 --port=8000

# Pastikan HP dan laptop dalam 1 WiFi!
```

## 📱 Setup Frontend (Flutter)

### 1. Prerequisites
- Flutter SDK 3.9+
- Dart 3.9+
- Android Studio / VS Code

### 2. Install Dependencies
```bash
cd ReBox_Project
flutter pub get
```

### 3. Konfigurasi API Base URL

Edit `lib/core/services/api_service.dart`:

**Emulator Android:**
```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

**Physical Device (HP):**
```dart
// Ganti dengan IP komputer (lihat ipconfig)
static const String baseUrl = 'http://192.168.1.28:8000/api';
```

**iOS Simulator:**
```dart
static const String baseUrl = 'http://127.0.0.1:8000/api';
```

### 4. Run Flutter App
```bash
# Untuk Emulator (buka emulator dulu):
flutter run

# Untuk Physical Device:
# - Colok HP via USB
# - Enable USB Debugging
# - Cek: flutter devices
flutter run
```

## 🔑 Demo Data

### User 1 - Demo User
- **Email:** demo@rebox.com
- **Password:** password123
- **Data:** 5 boxes, 21 items

### User 2 - John Doe
- **Email:** john@example.com
- **Password:** password123
- **Data:** 2 boxes, 2 items

### Kategori:
Elektronik, Pakaian, Buku, Dapur, Mainan, Alat Tulis, Olahraga, Dekorasi

## 🐛 Troubleshooting

### Laravel
**MySQL tidak connect:**
```bash
# Pastikan MySQL running (XAMPP/WAMP)
# Cek di Services > MySQL > Start
```

**Class 'DemoSeeder' not found:**
```bash
composer dump-autoload
php artisan migrate:fresh --seed
```

### Flutter
**Connection refused:**
- Pastikan Laravel server running
- Cek baseUrl sesuai platform
- Firewall tidak blokir port 8000

**401 Unauthorized:**
- Token expired
- Logout dan login ulang

**Emulator terlalu besar:**
```
Ctrl + -  (zoom out)
Ctrl + =  (zoom in)
```

**HP tidak terdeteksi:**
```bash
# Enable USB Debugging:
# Settings > About Phone > Tap Build Number 7x
# Developer Options > USB Debugging

adb devices
```

## 📚 API Endpoints

### Auth
- POST /api/register
- POST /api/login
- POST /api/logout
- GET /api/user

### Boxes (Auth Required)
- GET /api/boxes
- POST /api/boxes
- GET /api/boxes/{id}
- PUT /api/boxes/{id}
- DELETE /api/boxes/{id}

### Items (Auth Required)
- GET /api/items
- GET /api/boxes/{boxId}/items
- POST /api/items
- GET /api/items/{id}
- PUT /api/items/{id}
- DELETE /api/items/{id}

### Categories (Auth Required)
- GET /api/categories
- POST /api/categories
- PUT /api/categories/{id}
- DELETE /api/categories/{id}

## 📝 Response Format

**Success:**
```json
{
  "success": true,
  "message": "Success",
  "data": {}
}
```

**Error:**
```json
{
  "success": false,
  "message": "Error",
  "errors": {}
}
```

---

**Happy Coding! 🚀**
