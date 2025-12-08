# PANDUAN KONFIGURASI API

## 📍 Cara Menentukan Base URL yang Tepat

Base URL yang digunakan tergantung pada **platform testing** Anda:

### 1️⃣ Testing di Android Emulator (AVD)
```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```
- `10.0.2.2` adalah IP khusus untuk mengakses localhost dari Android Emulator
- TIDAK BOLEH pakai `127.0.0.1` atau `localhost` di emulator!

### 2️⃣ Testing di iOS Simulator
```dart
static const String baseUrl = 'http://127.0.0.1:8000/api';
```
- iOS Simulator bisa langsung akses localhost
- Bisa juga pakai `http://localhost:8000/api`

### 3️⃣ Testing di Physical Device (HP/Tablet)
```dart
static const String baseUrl = 'http://192.168.1.28:8000/api';
```
- Ganti `192.168.1.28` dengan IP komputer Anda
- HP dan komputer HARUS dalam **jaringan WiFi yang sama**!

---

## 🔍 Cara Cek IP Komputer

### Windows:
```bash
ipconfig
```
Cari bagian **IPv4 Address**, contoh: `192.168.1.28`

### macOS/Linux:
```bash
ifconfig
```
atau
```bash
ip addr show
```

---

## 🚀 Langkah Setup

### 1. Jalankan Laravel Server

**Untuk Emulator/Simulator:**
```bash
php artisan serve
# Server di: http://127.0.0.1:8000
```

**Untuk Physical Device:**
```bash
# Ganti dengan IP komputer Anda
php artisan serve --host=192.168.1.28 --port=8000
```

### 2. Edit ApiService

Buka file: `lib/core/services/api_service.dart`

Ganti baris 8 sesuai platform:
```dart
static const String baseUrl = 'http://YOUR_IP:8000/api';
```

### 3. Test Connection

Login dengan:
- **Email:** demo@rebox.com
- **Password:** password123

Jika muncul error "Connection refused":
- Cek Laravel server masih running
- Cek baseUrl sudah benar
- Cek firewall tidak blokir port 8000
- Untuk HP: pastikan dalam 1 WiFi dengan laptop

---

## 🛠 Troubleshooting

### ❌ Error: "Connection refused" / "Failed to connect"
**Penyebab:**
- Laravel server tidak running
- Base URL salah
- Firewall blokir port 8000
- HP tidak dalam 1 WiFi dengan laptop

**Solusi:**
```bash
# 1. Cek Laravel server
php artisan serve --host=0.0.0.0 --port=8000

# 2. Cek firewall (Windows)
# Control Panel > Windows Defender Firewall
# Allow port 8000

# 3. Cek IP
ipconfig

# 4. Test dari browser HP
# Buka: http://192.168.1.28:8000
# Harus muncul halaman Laravel
```

### ❌ Error: "401 Unauthorized"
**Penyebab:**
- Token expired
- Token tidak valid

**Solusi:**
- Logout dari app
- Login ulang
- Atau clear app data

### ❌ Error: "Network error" / "SocketException"
**Penyebab:**
- Tidak ada koneksi internet/WiFi
- Server tidak reachable

**Solusi:**
- Cek koneksi WiFi
- Ping server: `ping 192.168.1.28`
- Restart WiFi router

---

## 📱 Platform-Specific Notes

### Android Emulator
- **HARUS** pakai `10.0.2.2` bukan `127.0.0.1`
- Emulator punya network terpisah dari host
- `10.0.2.2` = alias untuk localhost dari emulator

### iOS Simulator
- Bisa langsung pakai `127.0.0.1`
- Simulator share network dengan macOS host
- Lebih mudah dari Android Emulator

### Physical Device
- Paling reliable untuk testing production
- Butuh config IP manual
- **Wajib** dalam 1 WiFi dengan development machine
- Bisa pakai USB tethering jika WiFi bermasalah

---

## ✅ Checklist Sebelum Testing

- [ ] Laravel server running (`php artisan serve`)
- [ ] Database sudah migrate & seed (`php artisan migrate:fresh --seed`)
- [ ] Base URL di `api_service.dart` sudah sesuai
- [ ] HP dalam 1 WiFi dengan laptop (untuk physical device)
- [ ] Firewall tidak blokir port 8000
- [ ] Test akses dari browser: `http://IP:8000`

---

## 💡 Tips

1. **Development:** Gunakan emulator untuk dev cepat
2. **Testing:** Gunakan physical device untuk UI/UX testing
3. **Production:** Deploy API ke server production (Heroku, DigitalOcean, dll)
4. **Debug:** Gunakan `flutter run --verbose` untuk lihat log detail
5. **Network:** Gunakan Charles Proxy / Postman untuk debug API calls

---

## 🔗 Resources

- [Laravel Docs](https://laravel.com/docs)
- [Flutter Networking](https://flutter.dev/docs/cookbook/networking)
- [Android Emulator Networking](https://developer.android.com/studio/run/emulator-networking)
