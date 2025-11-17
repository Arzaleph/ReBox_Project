# Koneksi API Laravel ke Flutter

## Setup Awal

### 1. Backend Laravel

Pastikan Laravel API sudah running:

```bash
cd BE
php artisan serve
```

Laravel akan berjalan di `http://127.0.0.1:8000`

**Penting:** Pastikan CORS sudah diaktifkan di Laravel (`config/cors.php`)

### 2. Flutter Frontend

Update base URL di `lib/core/services/api_service.dart`:

```dart
static const String baseUrl = 'http://127.0.0.1:8000/api';
```

**Untuk Android Emulator:** Gunakan `http://10.0.2.2:8000/api`  
**Untuk Physical Device:** Gunakan IP komputer Anda, misal `http://192.168.1.100:8000/api`

## Struktur File yang Dibuat

```
lib/core/
├── models/
│   ├── user.dart          # Model User
│   ├── box.dart           # Model Box
│   ├── item.dart          # Model Item
│   └── category.dart      # Model Category
├── services/
│   ├── api_service.dart      # Base API service untuk HTTP requests
│   ├── auth_service.dart     # Service untuk authentication
│   ├── box_service.dart      # Service untuk boxes
│   ├── item_service.dart     # Service untuk items
│   └── category_service.dart # Service untuk categories
└── examples/
    ├── login_example.dart    # Contoh halaman login
    └── box_list_example.dart # Contoh list boxes
```

## Cara Penggunaan

### 1. Authentication (Login/Register)

```dart
import 'package:project_pti/core/services/auth_service.dart';
import 'package:project_pti/core/services/api_service.dart';

final authService = AuthService();

// Login
try {
  final response = await authService.login(
    email: 'user@example.com',
    password: 'password',
  );
  print('Login berhasil: ${response['message']}');
  
  // Token otomatis tersimpan, siap untuk request berikutnya
  
} on ApiException catch (e) {
  print('Error: ${e.message}');
  print('Status: ${e.statusCode}');
}

// Register
try {
  final response = await authService.register(
    name: 'John Doe',
    email: 'john@example.com',
    password: 'password123',
    passwordConfirmation: 'password123',
  );
  print('Register berhasil');
} on ApiException catch (e) {
  print('Error: ${e.message}');
}

// Logout
await authService.logout();

// Check login status
bool isLoggedIn = await authService.isLoggedIn();

// Get current user
final user = await authService.getCurrentUser();
print('Nama: ${user.name}');
```

### 2. Boxes (CRUD)

```dart
import 'package:project_pti/core/services/box_service.dart';
import 'package:project_pti/core/models/box.dart';

final boxService = BoxService();

// Get all boxes
List<Box> boxes = await boxService.getAllBoxes();

// Get single box
Box box = await boxService.getBox(1);

// Create box
Box newBox = await boxService.createBox(
  name: 'Box Ruang Tamu',
  description: 'Barang-barang ruang tamu',
);

// Update box
Box updatedBox = await boxService.updateBox(
  id: 1,
  name: 'Box Kamar',
  description: 'Barang-barang kamar tidur',
);

// Delete box
await boxService.deleteBox(1);
```

### 3. Items (CRUD)

```dart
import 'package:project_pti/core/services/item_service.dart';
import 'package:project_pti/core/models/item.dart';

final itemService = ItemService();

// Get all items
List<Item> items = await itemService.getAllItems();

// Get single item
Item item = await itemService.getItem(1);

// Create item
Item newItem = await itemService.createItem(
  name: 'Buku',
  description: 'Buku Programming',
  boxId: 1,
  categoryId: 2,
  quantity: 5,
);

// Update item
Item updatedItem = await itemService.updateItem(
  id: 1,
  name: 'Buku Flutter',
  description: 'Buku tentang Flutter',
  boxId: 1,
  categoryId: 2,
  quantity: 3,
);

// Delete item
await itemService.deleteItem(1);
```

### 4. Categories (CRUD)

```dart
import 'package:project_pti/core/services/category_service.dart';
import 'package:project_pti/core/models/category.dart';

final categoryService = CategoryService();

// Get all categories
List<Category> categories = await categoryService.getAllCategories();

// Get single category
Category category = await categoryService.getCategory(1);

// Create category
Category newCategory = await categoryService.createCategory(
  name: 'Elektronik',
  description: 'Barang elektronik',
);

// Update category
Category updatedCategory = await categoryService.updateCategory(
  id: 1,
  name: 'Elektronik Rumah',
  description: 'Peralatan elektronik rumah tangga',
);

// Delete category
await categoryService.deleteCategory(1);
```

## Error Handling

Semua service menggunakan exception handling yang konsisten:

```dart
try {
  final boxes = await boxService.getAllBoxes();
  // Success
} on ApiException catch (e) {
  // API error dengan response dari server
  print('Error: ${e.message}');
  print('Status Code: ${e.statusCode}');
  print('Errors: ${e.errors}'); // Validation errors dari Laravel
} catch (e) {
  // Network error atau error lainnya
  print('Unexpected error: $e');
}
```

## Contoh Implementasi di Widget

### Contoh 1: Login Screen

Lihat file `lib/core/examples/login_example.dart` untuk implementasi lengkap form login.

### Contoh 2: List Boxes dengan Pull-to-Refresh

Lihat file `lib/core/examples/box_list_example.dart` untuk implementasi lengkap list dengan:
- Loading state
- Error handling
- Pull to refresh
- Delete confirmation

## Tips & Best Practices

1. **Always handle exceptions:** Gunakan try-catch untuk semua API calls
2. **Loading states:** Tampilkan loading indicator saat fetch data
3. **Refresh data:** Implementasikan pull-to-refresh untuk user experience yang lebih baik
4. **Token persistence:** Token otomatis tersimpan di SharedPreferences
5. **401 Unauthorized:** Jika dapat error 401, redirect ke login screen

## Testing API

Anda bisa test API menggunakan:

1. **Postman/Insomnia** untuk test endpoints Laravel
2. **Flutter DevTools** untuk debug network requests
3. Gunakan `print()` untuk log response data saat development

## Troubleshooting

### Connection Refused
- Pastikan Laravel server running (`php artisan serve`)
- Cek base URL sudah benar
- Untuk Android Emulator gunakan `10.0.2.2` bukan `127.0.0.1`

### CORS Error
- Pastikan CORS diaktifkan di Laravel
- Check `config/cors.php` dan `app/Http/Middleware/HandleCors.php`

### 401 Unauthorized
- Token expired atau invalid
- Logout dan login ulang
- Check token tersimpan dengan benar

### Validation Errors
- Laravel mengirim validation errors di field `errors`
- Access via `ApiException.errors`
