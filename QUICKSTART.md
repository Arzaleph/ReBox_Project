# Quick Start - API Integration

## 1. Update Base URL

Edit `lib/core/services/api_service.dart` baris 7:

```dart
static const String baseUrl = 'http://127.0.0.1:8000/api';
```

**Penting:**
- Local: `http://127.0.0.1:8000/api`
- Android Emulator: `http://10.0.2.2:8000/api`
- Physical Device: `http://YOUR_COMPUTER_IP:8000/api`

## 2. Jalankan Laravel Backend

```bash
cd BE
php artisan serve
```

## 3. Contoh Penggunaan Cepat

### Login
```dart
import 'package:project_pti/core/services/auth_service.dart';

final authService = AuthService();

try {
  await authService.login(
    email: 'user@example.com',
    password: 'password',
  );
  // Login berhasil, token tersimpan otomatis
} catch (e) {
  print('Login gagal: $e');
}
```

### Get Data Boxes
```dart
import 'package:project_pti/core/services/box_service.dart';

final boxService = BoxService();

try {
  final boxes = await boxService.getAllBoxes();
  // boxes berisi List<Box>
  for (var box in boxes) {
    print(box.name);
  }
} catch (e) {
  print('Error: $e');
}
```

### Create Box
```dart
try {
  final newBox = await boxService.createBox(
    name: 'Box Dapur',
    description: 'Peralatan dapur',
  );
  print('Box created: ${newBox.name}');
} catch (e) {
  print('Error: $e');
}
```

### Update Box
```dart
try {
  await boxService.updateBox(
    id: 1,
    name: 'Box Dapur Updated',
    description: 'Peralatan dapur lengkap',
  );
  print('Box updated');
} catch (e) {
  print('Error: $e');
}
```

### Delete Box
```dart
try {
  await boxService.deleteBox(1);
  print('Box deleted');
} catch (e) {
  print('Error: $e');
}
```

## 4. Contoh Widget Lengkap

Lihat file berikut untuk contoh implementasi:
- `lib/core/examples/login_example.dart` - Form login lengkap
- `lib/core/examples/box_list_example.dart` - List dengan CRUD
- `lib/core/examples/api_usage_examples.dart` - Semua contoh API usage

## 5. Error Handling

```dart
import 'package:project_pti/core/services/api_service.dart';

try {
  // API call here
} on ApiException catch (e) {
  // Handle API errors
  print('Status: ${e.statusCode}');
  print('Message: ${e.message}');
  print('Errors: ${e.errors}'); // validation errors
} catch (e) {
  // Handle other errors (network, etc)
  print('Error: $e');
}
```

## 6. Available Services

```dart
import 'package:project_pti/core/services/auth_service.dart';
import 'package:project_pti/core/services/box_service.dart';
import 'package:project_pti/core/services/item_service.dart';
import 'package:project_pti/core/services/category_service.dart';

final authService = AuthService();
final boxService = BoxService();
final itemService = ItemService();
final categoryService = CategoryService();
```

## 7. Models

```dart
import 'package:project_pti/core/models/user.dart';
import 'package:project_pti/core/models/box.dart';
import 'package:project_pti/core/models/item.dart';
import 'package:project_pti/core/models/category.dart';
```

---

Untuk dokumentasi lengkap, lihat file **API_INTEGRATION_GUIDE.md**
