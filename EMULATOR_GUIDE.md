# 🎮 PANDUAN RUN FLUTTER DI EMULATOR ANDROID

## ✅ YANG SUDAH DILAKUKAN:

### 1. **Emulator Started** ✅
- Emulator: `Medium_Phone_API_36.1`
- Device ID: `emulator-5554`
- Android Version: Android 16 (API 36)
- Status: **RUNNING**

### 2. **Base URL Updated** ✅
File: `lib/core/services/api_service.dart`
```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

**PENTING:** 
- `10.0.2.2` = IP khusus untuk akses localhost dari Android Emulator
- JANGAN pakai `127.0.0.1` atau `10.4.5.19` di emulator!

### 3. **Flutter Build Started** ✅
```bash
flutter run -d emulator-5554
```
Status: Building (first build takes 2-5 minutes)

---

## 🚀 LANGKAH-LANGKAH LENGKAP:

### **A. Start Emulator (Sudah Done ✅)**
```bash
flutter emulators --launch Medium_Phone_API_36.1
```

### **B. Check Device (Sudah Done ✅)**
```bash
flutter devices
# Output:
# sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64
```

### **C. Run App (Sedang Berjalan...)**
```bash
cd e:\REBOX\ReBox_Project
flutter run -d emulator-5554
```

---

## 📝 CHECKLIST SEBELUM TESTING:

- [x] Emulator running
- [x] Base URL = `10.0.2.2:8000/api`
- [x] Flutter dependencies installed
- [ ] Laravel server running di `localhost:8000`
- [ ] App installed di emulator
- [ ] Login test dengan demo@rebox.com

---

## 🔧 PERINTAH PENTING:

### **Check Emulator:**
```bash
flutter emulators
```

### **Start Emulator:**
```bash
flutter emulators --launch Medium_Phone_API_36.1
```

### **Check Connected Devices:**
```bash
flutter devices
```

### **Run App:**
```bash
cd e:\REBOX\ReBox_Project
flutter run
# Atau spesifik ke emulator:
flutter run -d emulator-5554
```

### **Hot Reload (Setelah App Running):**
- Tekan `r` di terminal = reload
- Tekan `R` di terminal = hot restart
- Tekan `q` = quit

### **Stop Emulator:**
- Close emulator window, atau:
```bash
adb -s emulator-5554 emu kill
```

---

## ⚠️ TROUBLESHOOTING:

### **Error: "Connection refused"**
**Problem:** Laravel server tidak running
**Solusi:**
```bash
cd e:\REBOX\BE
php artisan serve
# Untuk emulator, localhost sudah cukup
```

### **Error: "Gradle build failed"**
**Problem:** Android SDK atau Gradle issue
**Solusi:**
```bash
cd e:\REBOX\ReBox_Project\android
gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### **Emulator Lambat/Lag**
**Solusi:**
1. Tutup aplikasi lain yang berat
2. Restart emulator
3. Atau buat emulator baru dengan specs lebih rendah:
```bash
flutter emulators --create --name small_phone
```

### **Error: "10.0.2.2 not reachable"**
**Problem:** Laravel server tidak running atau port salah
**Solusi:**
1. Pastikan Laravel server running:
```bash
cd e:\REBOX\BE
php artisan serve
# Jangan pakai --host, biarkan default localhost
```

2. Test dari emulator browser:
- Buka Chrome di emulator
- Akses: `http://10.0.2.2:8000`
- Harus muncul halaman Laravel

---

## 🎯 TIPS & TRICKS:

### **1. Resize Emulator**
Kalau emulator terlalu besar:
- Drag corner untuk resize
- Atau di toolbar emulator: Settings > Window Size

### **2. Keyboard Shortcuts di Emulator:**
- `Ctrl + M` = Menu
- `Ctrl + K` = Keyboard show/hide
- `Ctrl + Left/Right` = Rotate

### **3. Debug Mode:**
Kalau app sudah running, tekan `?` di terminal untuk lihat semua commands:
```
r - Hot reload
R - Hot restart
h - Help
d - Detach (run in background)
q - Quit
```

### **4. View Logs:**
```bash
# Di terminal lain:
flutter logs
```

### **5. Install APK Manual (jika perlu):**
```bash
flutter build apk --debug
adb -s emulator-5554 install build/app/outputs/flutter-apk/app-debug.apk
```

---

## 🌐 NETWORK MAPPING:

| Your Machine | Emulator |
|-------------|----------|
| 127.0.0.1:8000 | 10.0.2.2:8000 |
| localhost:8000 | 10.0.2.2:8000 |

**Catatan:** Emulator punya network tersendiri, jadi:
- `10.0.2.2` = localhost/127.0.0.1 di host machine
- `10.0.2.3` = DNS server
- `10.0.2.15` = Emulator IP

---

## 📊 EXPECTED BEHAVIOR:

### **1. First Build (2-5 menit)**
```
Running Gradle task 'assembleDebug'...
✓ Built build\app\outputs\flutter-apk\app-debug.apk.
Installing build\app\outputs\flutter-apk\app.apk...
```

### **2. App Installed & Running**
```
Syncing files to device sdk gphone64 x86 64...
Flutter run key commands.
r Hot reload.
R Hot restart.
...
```

### **3. Splash Screen Muncul**
App akan show splash screen ReBox

### **4. Auto Navigate**
- Jika belum login → Login Screen
- Jika sudah login → Main Screen

---

## 🔑 TEST LOGIN:

**Demo Account:**
- Email: `demo@rebox.com`
- Password: `password123`

**Expected Result:**
- Login berhasil
- Navigate ke MainScreen/Beranda
- Bisa lihat boxes & items

---

## 📱 EMULATOR vs PHYSICAL DEVICE:

| Aspect | Emulator | Physical Device |
|--------|----------|----------------|
| Base URL | `10.0.2.2:8000/api` | `10.4.5.19:8000/api` |
| Setup | Sudah ada ✅ | Butuh USB & enable debugging |
| Performance | Medium (tergantung laptop) | Fast |
| Best For | Development & Testing | Demo & Production Test |

---

## 🚦 STATUS SAAT INI:

✅ Emulator: **RUNNING**
✅ Base URL: **CONFIGURED** (`10.0.2.2:8000/api`)
⏳ App Build: **IN PROGRESS**
⏸️ Laravel Server: **NOT RUNNING** (harus distart!)

---

## ⚡ NEXT STEPS:

1. **Tunggu build selesai** (2-5 menit first time)
2. **Start Laravel server** di terminal lain:
   ```bash
   cd e:\REBOX\BE
   php artisan serve
   ```
3. **Test login** di app yang sudah running di emulator
4. **Enjoy!** 🎉

---

**Build sedang berjalan... Tunggu sampai muncul "Hot reload enabled" di terminal!**
