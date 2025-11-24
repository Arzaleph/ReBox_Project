# 🎨 FITUR UPLOAD AVATAR/FOTO PROFIL - COMPLETE

## ✅ YANG SUDAH DIIMPLEMENTASI:

### 🔧 **Backend (Laravel)**

#### 1. **Database Migration** ✅
File: `database/migrations/2025_11_16_145138_add_fields_to_users_table.php`

**Kolom baru di tabel users:**
- `avatar` (string, nullable) - path ke file avatar
- `phone` (string, nullable) - nomor telepon
- `bio` (text, nullable) - bio user

#### 2. **User Model Update** ✅
File: `app/Models/User.php`

**Fillable ditambahkan:**
- avatar
- phone
- bio

#### 3. **API Endpoints** ✅
File: `app/Http/Controllers/Api/AuthController.php`

**Endpoint baru:**

**GET /api/profile**
- Get user profile dengan avatar URL
- Response: user data + avatar_url

**PUT /api/profile**
- Update name, phone, bio
- Body: { name?, phone?, bio? }

**POST /api/profile/avatar**
- Upload avatar (multipart/form-data)
- File: avatar (image, max 2MB)
- Supported: jpeg, png, jpg, gif
- Auto delete avatar lama
- Response: user data + avatar_url

#### 4. **File Storage** ✅
- Directory: `public/uploads/avatars/`
- Format: `avatar_{userId}_{timestamp}.{ext}`
- Auto cleanup old avatars

---

### 📱 **Frontend (Flutter)**

#### 1. **Dependencies** ✅
File: `pubspec.yaml`

**Package ditambahkan:**
```yaml
image_picker: ^1.0.4        # Pick image dari galeri/kamera
cached_network_image: ^3.3.0  # Cache & display network images
```

#### 2. **User Model Update** ✅
File: `lib/core/models/user.dart`

**Field baru:**
- `String? avatar`
- `String? phone`
- `String? bio`

#### 3. **ProfileService** ✅
File: `lib/core/services/profile_service.dart`

**Methods:**
- `getProfile()` - Get user profile
- `updateProfile({name, phone, bio})` - Update profile data
- `uploadAvatar(File imageFile)` - Upload avatar via multipart
- `getAvatarUrl(User user)` - Build full avatar URL

#### 4. **Edit Profile Screen** ✅
File: `lib/profil/screens/edit_profile_screen.dart`

**Features:**
- ✅ Display current avatar atau icon default
- ✅ Tap camera icon untuk pilih foto
- ✅ Bottom sheet: Galeri atau Kamera
- ✅ Preview foto sebelum upload
- ✅ Auto upload setelah pilih foto
- ✅ Loading indicator saat upload
- ✅ Form: Name, Phone, Bio
- ✅ Email (read-only)
- ✅ Validation
- ✅ Save button

#### 5. **UserAvatar Widget** ✅
File: `lib/core/widgets/user_avatar.dart`

**Reusable widget untuk display avatar:**
- Cached network image
- Fallback ke icon default
- Customizable size
- Optional border
- Loading placeholder

#### 6. **Android Permissions** ✅
File: `android/app/src/main/AndroidManifest.xml`

**Permissions ditambahkan:**
- `CAMERA` - Akses kamera
- `READ_EXTERNAL_STORAGE` - Baca galeri
- `WRITE_EXTERNAL_STORAGE` - Simpan foto (SDK ≤ 32)
- `READ_MEDIA_IMAGES` - Baca media images (SDK ≥ 33)

---

## 🚀 CARA MENGGUNAKAN:

### **1. Setup Backend**

Database sudah di-migrate, tidak perlu action.

### **2. Install Flutter Packages**
```bash
cd e:\REBOX\ReBox_Project
flutter pub get
```
✅ **Already done!**

### **3. Build & Run**
```bash
# Hot restart jika app sudah running
# Tekan 'R' di terminal Flutter

# Atau rebuild:
flutter run -d emulator-5554
```

### **4. Navigasi ke Edit Profile**

Dari Profile Screen, tambahkan button/menu untuk buka `EditProfileScreen`:

```dart
import 'package:project_pti/profil/screens/edit_profile_screen.dart';

// Di ProfileScreen:
ElevatedButton(
  onPressed: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );
    
    // Jika result == true, reload profile
    if (result == true) {
      // Reload profile data
    }
  },
  child: const Text('Edit Profile'),
)
```

### **5. Upload Avatar Flow:**

1. **Buka Edit Profile Screen**
2. **Tap camera icon** di avatar
3. **Pilih sumber:**
   - 📸 Take Photo (kamera)
   - 🖼️ Choose from Gallery
4. **Select photo**
5. **Auto upload** (loading indicator)
6. **Success!** Avatar ter-update

### **6. Update Profile Data:**

1. Edit Name, Phone, atau Bio
2. Tap **Save** button
3. Profile ter-update
4. Kembali ke profile screen

---

## 📋 API REFERENCE:

### **Get Profile**
```
GET /api/profile
Authorization: Bearer {token}

Response:
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "name": "Demo User",
      "email": "demo@rebox.com",
      "avatar": "uploads/avatars/avatar_1_1234567890.jpg",
      "phone": "081234567890",
      "bio": "This is my bio",
      "created_at": "2025-11-24T...",
      "updated_at": "2025-11-24T..."
    },
    "avatar_url": "http://10.0.2.2:8000/uploads/avatars/avatar_1_1234567890.jpg"
  }
}
```

### **Update Profile**
```
PUT /api/profile
Authorization: Bearer {token}
Content-Type: application/json

Body:
{
  "name": "New Name",
  "phone": "081234567890",
  "bio": "My new bio"
}

Response:
{
  "success": true,
  "message": "Profil berhasil diupdate",
  "data": { user object }
}
```

### **Upload Avatar**
```
POST /api/profile/avatar
Authorization: Bearer {token}
Content-Type: multipart/form-data

Form Data:
avatar: (binary file)

Response:
{
  "success": true,
  "message": "Avatar berhasil diupdate",
  "data": {
    "user": { user object },
    "avatar_url": "http://10.0.2.2:8000/uploads/avatars/avatar_1_1234567890.jpg"
  }
}
```

---

## 🎨 UI/UX FEATURES:

### **Avatar Display:**
- ✅ Circular avatar
- ✅ Default icon jika belum upload
- ✅ Cached untuk performance
- ✅ Loading placeholder
- ✅ Error fallback

### **Upload Experience:**
- ✅ Camera icon overlay
- ✅ Bottom sheet untuk pilih sumber
- ✅ Preview sebelum upload
- ✅ Loading indicator overlay
- ✅ Success/error feedback

### **Form:**
- ✅ Material Design
- ✅ Validation
- ✅ Disabled state saat loading
- ✅ Character count (bio)
- ✅ Email read-only dengan hint

---

## 🔒 SECURITY & VALIDATION:

### **Backend:**
- ✅ File type validation (jpeg, png, jpg, gif only)
- ✅ File size limit (max 2MB)
- ✅ Authenticated endpoints only
- ✅ Auto delete old avatar
- ✅ Sanitized filename

### **Frontend:**
- ✅ Image compression (maxWidth: 1024, quality: 85%)
- ✅ Form validation
- ✅ Error handling
- ✅ Network error handling

---

## 📁 FILE STRUCTURE:

```
BE/
├── app/
│   ├── Http/Controllers/Api/
│   │   └── AuthController.php ✅ (updated)
│   └── Models/
│       └── User.php ✅ (updated)
├── database/migrations/
│   └── 2025_11_16_145138_add_fields_to_users_table.php ✅
├── routes/
│   └── api.php ✅ (updated)
└── public/uploads/avatars/ ✅ (created)

ReBox_Project/
├── lib/
│   ├── core/
│   │   ├── models/
│   │   │   └── user.dart ✅ (updated)
│   │   ├── services/
│   │   │   ├── api_service.dart ✅ (updated)
│   │   │   └── profile_service.dart ✅ (new)
│   │   └── widgets/
│   │       └── user_avatar.dart ✅ (new)
│   └── profil/
│       └── screens/
│           └── edit_profile_screen.dart ✅ (new)
├── android/app/src/main/
│   └── AndroidManifest.xml ✅ (updated)
└── pubspec.yaml ✅ (updated)
```

---

## 🧪 TESTING:

### **Test Upload Avatar:**
1. Login dengan demo@rebox.com
2. Buka Edit Profile
3. Tap camera icon
4. Pilih "Choose from Gallery"
5. Select foto
6. Tunggu upload selesai
7. Verify avatar muncul
8. Kembali ke profile, verify avatar tersimpan

### **Test Update Profile:**
1. Edit nama → Save
2. Add phone → Save
3. Add bio → Save
4. Verify semua tersimpan

### **Test Image Picker:**
1. Test dari Gallery ✅
2. Test dari Camera ✅ (need physical device/emulator with camera)
3. Test upload foto besar (akan di-compress)
4. Test upload foto kecil

---

## ⚙️ CONFIGURATION:

### **Avatar Storage:**
```php
// Laravel
public/uploads/avatars/
// Format: avatar_{userId}_{timestamp}.{ext}
```

### **Image Compression:**
```dart
// Flutter (image_picker)
maxWidth: 1024
maxHeight: 1024
imageQuality: 85
```

### **File Size Limit:**
```php
// Laravel
'avatar' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048' // 2MB
```

---

## 🐛 TROUBLESHOOTING:

### **Error: "Permission denied"**
**Problem:** Android permissions tidak granted

**Solution:**
1. Uninstall app
2. Rebuild & install
3. Grant permissions saat diminta
4. Atau: Settings > Apps > ReBox > Permissions

### **Error: "Upload failed"**
**Problem:** File terlalu besar atau format salah

**Solution:**
- Check file size < 2MB
- Check format: jpeg, png, jpg, gif
- Check network connection
- Check Laravel server running

### **Avatar tidak muncul**
**Problem:** URL tidak accessible

**Solution:**
- Check Laravel server running
- Check base URL di ApiService
- Check file exists di `public/uploads/avatars/`
- Check avatar path di database

---

## 📚 NEXT STEPS (Optional Enhancements):

### **1. Remove Avatar**
Implement delete avatar endpoint:
```php
// AuthController.php
public function removeAvatar(Request $request) {
  $user = $request->user();
  if ($user->avatar && file_exists(public_path($user->avatar))) {
    unlink(public_path($user->avatar));
  }
  $user->update(['avatar' => null]);
  // ...
}
```

### **2. Avatar Cropper**
Add image cropping:
```yaml
# pubspec.yaml
image_cropper: ^5.0.0
```

### **3. Multiple Photos**
Allow multiple profile photos (gallery)

### **4. Avatar Filters**
Add filters/effects to avatar

### **5. Default Avatars**
Provide default avatar options

---

## ✅ SUMMARY:

**Backend:**
- ✅ 3 columns added (avatar, phone, bio)
- ✅ 3 new endpoints (profile CRUD + avatar upload)
- ✅ File upload handling
- ✅ Auto cleanup

**Frontend:**
- ✅ 2 packages (image_picker, cached_network_image)
- ✅ ProfileService with multipart upload
- ✅ EditProfileScreen with full UI
- ✅ UserAvatar reusable widget
- ✅ Android permissions

**Status:** ✅ **READY TO USE!**

---

**🎉 Fitur upload avatar sudah lengkap dan siap digunakan!**

Hot restart Flutter app dan test upload avatar sekarang! 📸
