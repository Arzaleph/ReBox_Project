import 'package:flutter/material.dart';
import 'package:project_pti/core/services/auth_service.dart';
import 'package:project_pti/core/models/user.dart';
import 'login_screen.dart';
import '../../beranda/screens/beranda_screen.dart';
import '../../admin/screens/admin_dashboard_screen.dart';
import '../../pengepul/screens/pengepul_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Delay untuk splash screen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check apakah user sudah login
    final isLoggedIn = await _authService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      // Coba validasi token dengan get user
      try {
        final User user = await _authService.getCurrentUser();
        
        // Token valid, redirect based on role
        if (mounted) {
          Widget destination;
          
          if (user.isAdmin) {
            // Admin -> Admin Dashboard
            destination = const AdminDashboardScreen();
          } else if (user.isPengepul) {
            // Pengepul -> Pengepul Dashboard
            destination = const PengepulDashboardScreen();
          } else {
            // Pengguna -> Regular Home Screen
            destination = const MainScreen();
          }
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      } catch (e) {
        // Token invalid atau expired, ke login
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    } else {
      // Belum login, ke login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              
              // App Name
              const Text(
                'ReBox',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              
              const Text(
                'Kelola Box & Item Anda',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 48),
              
              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
