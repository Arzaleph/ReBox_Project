import 'package:flutter/material.dart';
import 'package:project_pti/beranda/screens/beranda_screen.dart'; // Impor layar fitur utama
import 'package:project_pti/pengaturan/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SettingsService.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Recycle Box',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent, brightness: Brightness.dark),
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          themeMode: SettingsService.instance.themeMode,
          home: const MainScreen(),

        );
      },
    );
  }
}

// Hapus kelas MyHomePage dan _MyHomePageState yang ada
// Pindahkan logika aplikasi Anda ke dalam folder fitur yang sesuai.