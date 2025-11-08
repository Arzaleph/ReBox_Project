import 'package:flutter/material.dart';
import 'package:project_pti/beranda/screens/beranda_screen.dart'; // Impor layar fitur utama

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project PTI',
      theme: ThemeData(
        // Sesuaikan tema aplikasi di sini, atau impor dari core/theme/app_theme.dart
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Atur halaman utama ke BerandaScreen
      home: const MainScreen(),

      // Atau, jika menggunakan named routes:
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const BerandaScreen(),
      //   // Tambahkan rute fitur lain di sini:
      //   // '/profil': (context) => const ProfilScreen(),
      // },
    );
  }
}

// Hapus kelas MyHomePage dan _MyHomePageState yang ada
// Pindahkan logika aplikasi Anda ke dalam folder fitur yang sesuai.