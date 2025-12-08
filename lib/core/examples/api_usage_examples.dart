import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/box_service.dart';
import '../services/item_service.dart';
import '../services/category_service.dart';
import '../models/box.dart';
import '../models/item.dart';
import '../models/category.dart';
import '../services/api_service.dart';

/// Contoh penggunaan lengkap API Service
/// Copy code yang Anda butuhkan ke screen Anda sendiri

class ApiUsageExamples {
  final authService = AuthService();
  final boxService = BoxService();
  final itemService = ItemService();
  final categoryService = CategoryService();

  // ============================================
  // AUTHENTICATION EXAMPLES
  // ============================================

  /// Contoh Login
  Future<void> exampleLogin(BuildContext context) async {
    try {
      final response = await authService.login(
        email: 'user@example.com',
        password: 'password',
      );

      // Login berhasil, token otomatis tersimpan
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Login berhasil!')),
        );
        
        // Navigate ke home
        // Navigator.pushReplacement(context, MaterialPageRoute(...));
      }
    } on ApiException catch (e) {
      // Handle API errors
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login gagal: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      // Specific error handling
      if (e.statusCode == 401) {
        print('Email atau password salah');
      } else if (e.statusCode == 422) {
        print('Validation errors: ${e.errors}');
      }
    } catch (e) {
      // Handle network errors
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Koneksi gagal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Contoh Register
  Future<void> exampleRegister(BuildContext context) async {
    try {
      final response = await authService.register(
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Registrasi berhasil!')),
        );
      }
    } on ApiException catch (e) {
      // Validation errors dari Laravel
      if (e.errors != null) {
        print('Validation errors:');
        e.errors!.forEach((key, value) {
          print('$key: ${value.join(', ')}');
        });
      }
    }
  }

  /// Contoh Logout
  Future<void> exampleLogout(BuildContext context) async {
    try {
      await authService.logout();
      
      if (context.mounted) {
        // Navigate to login screen
        // Navigator.pushAndRemoveUntil(context, ...);
      }
    } catch (e) {
      print('Logout error: $e');
    }
  }

  /// Contoh Get Current User
  Future<void> exampleGetCurrentUser() async {
    try {
      final user = await authService.getCurrentUser();
      print('User ID: ${user.id}');
      print('Name: ${user.name}');
      print('Email: ${user.email}');
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        print('Token expired, please login again');
      }
    }
  }

  /// Contoh Check Login Status
  Future<void> exampleCheckLogin() async {
    final isLoggedIn = await authService.isLoggedIn();
    if (isLoggedIn) {
      print('User is logged in');
    } else {
      print('User is not logged in');
    }
  }

  // ============================================
  // BOX EXAMPLES
  // ============================================

  /// Contoh Get All Boxes
  Future<List<Box>> exampleGetAllBoxes() async {
    try {
      final boxes = await boxService.getAllBoxes();
      
      for (var box in boxes) {
        print('Box: ${box.name} - ${box.description}');
      }
      
      return boxes;
    } on ApiException catch (e) {
      print('Error: ${e.message}');
      return [];
    }
  }

  /// Contoh Get Single Box
  Future<Box?> exampleGetSingleBox(int id) async {
    try {
      final box = await boxService.getBox(id);
      print('Box found: ${box.name}');
      return box;
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        print('Box not found');
      }
      return null;
    }
  }

  /// Contoh Create Box
  Future<void> exampleCreateBox(BuildContext context) async {
    try {
      final newBox = await boxService.createBox(
        name: 'Box Ruang Tamu',
        description: 'Barang-barang di ruang tamu',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Box "${newBox.name}" berhasil dibuat!')),
        );
      }
    } on ApiException catch (e) {
      if (e.statusCode == 422) {
        // Validation errors
        print('Validation failed: ${e.errors}');
      }
    }
  }

  /// Contoh Update Box
  Future<void> exampleUpdateBox(int id, BuildContext context) async {
    try {
      await boxService.updateBox(
        id: id,
        name: 'Box Kamar Tidur',
        description: 'Barang-barang kamar tidur',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Box berhasil diupdate!')),
        );
      }
    } on ApiException catch (e) {
      if (e.statusCode == 403) {
        print('Unauthorized: Anda tidak punya akses untuk edit box ini');
      } else if (e.statusCode == 404) {
        print('Box not found');
      }
    }
  }

  /// Contoh Delete Box
  Future<void> exampleDeleteBox(int id, BuildContext context) async {
    try {
      await boxService.deleteBox(id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Box berhasil dihapus!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ============================================
  // ITEM EXAMPLES
  // ============================================

  /// Contoh Get All Items
  Future<List<Item>> exampleGetAllItems() async {
    try {
      final items = await itemService.getAllItems();
      
      for (var item in items) {
        print('Item: ${item.name} - Qty: ${item.quantity}');
      }
      
      return items;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  /// Contoh Create Item
  Future<void> exampleCreateItem(BuildContext context) async {
    try {
      final newItem = await itemService.createItem(
        name: 'Buku Flutter',
        description: 'Buku tentang Flutter Development',
        boxId: 1,
        categoryId: 2,
        quantity: 5,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item "${newItem.name}" berhasil ditambahkan!')),
        );
      }
    } on ApiException catch (e) {
      print('Error: ${e.message}');
      if (e.errors != null) {
        e.errors!.forEach((key, value) {
          print('$key: ${value.join(', ')}');
        });
      }
    }
  }

  /// Contoh Update Item
  Future<void> exampleUpdateItem(int id) async {
    try {
      await itemService.updateItem(
        id: id,
        name: 'Buku Flutter Updated',
        description: 'Updated description',
        boxId: 1,
        categoryId: 2,
        quantity: 3,
      );
      print('Item berhasil diupdate');
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Contoh Delete Item
  Future<void> exampleDeleteItem(int id) async {
    try {
      await itemService.deleteItem(id);
      print('Item berhasil dihapus');
    } catch (e) {
      print('Error: $e');
    }
  }

  // ============================================
  // CATEGORY EXAMPLES
  // ============================================

  /// Contoh Get All Categories
  Future<List<Category>> exampleGetAllCategories() async {
    try {
      final categories = await categoryService.getAllCategories();
      
      for (var category in categories) {
        print('Category: ${category.name}');
      }
      
      return categories;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  /// Contoh Create Category
  Future<void> exampleCreateCategory(BuildContext context) async {
    try {
      final newCategory = await categoryService.createCategory(
        name: 'Elektronik',
        description: 'Barang-barang elektronik',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kategori "${newCategory.name}" berhasil dibuat!')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // ============================================
  // WIDGET IMPLEMENTATION EXAMPLES
  // ============================================

  /// Contoh StatefulWidget dengan API call
  /// Lihat BoxListWidget di bawah untuk implementasi lengkap
}

// ============================================
// COMPLETE WIDGET EXAMPLE
// ============================================

// Contoh complete widget dengan state management
class BoxListWidget extends StatefulWidget {
  const BoxListWidget({super.key});

  @override
  State<BoxListWidget> createState() => _BoxListWidgetState();
}

class _BoxListWidgetState extends State<BoxListWidget> {
  final boxService = BoxService();
  List<Box> boxes = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBoxes();
  }

  Future<void> _loadBoxes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedBoxes = await boxService.getAllBoxes();
      setState(() {
        boxes = fetchedBoxes;
        isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        errorMessage = e.message;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loadBoxes,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (boxes.isEmpty) {
      return const Center(child: Text('Tidak ada box'));
    }

    return RefreshIndicator(
      onRefresh: _loadBoxes,
      child: ListView.builder(
        itemCount: boxes.length,
        itemBuilder: (context, index) {
          final box = boxes[index];
          return ListTile(
            title: Text(box.name),
            subtitle: Text(box.description ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteBox(box.id),
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteBox(int id) async {
    try {
      await boxService.deleteBox(id);
      _loadBoxes(); // Reload
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Box berhasil dihapus')),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
