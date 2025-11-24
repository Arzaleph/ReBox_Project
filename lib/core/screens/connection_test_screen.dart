import 'package:flutter/material.dart';
import 'package:project_pti/core/services/api_service.dart';
import 'package:project_pti/core/services/auth_service.dart';

/// Screen untuk test koneksi BE-FE
/// Berguna untuk debugging connection issues
class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  final _authService = AuthService();
  
  bool _isTestingConnection = false;
  String _testResult = '';
  Color _resultColor = Colors.grey;

  Future<void> _testConnection() async {
    setState(() {
      _isTestingConnection = true;
      _testResult = 'Testing connection...';
      _resultColor = Colors.blue;
    });

    try {
      // Test 1: Ping server (try to login with dummy credentials)
      await _authService.login(
        email: 'test@test.com',
        password: 'test123',
      );
      
      // If we get here without exception (unlikely), connection works
      setState(() {
        _testResult = '✅ Connection successful!\nServer is reachable.';
        _resultColor = Colors.green;
      });
    } on ApiException catch (e) {
      // If we get API error (401, 422, etc), it means server is reachable!
      if (e.statusCode == 401 || e.statusCode == 422) {
        setState(() {
          _testResult = '✅ Connection successful!\n'
              'Server responded with: ${e.statusCode}\n'
              'Base URL: ${ApiService.baseUrl}\n\n'
              'Note: Credentials invalid (expected), but server is reachable!';
          _resultColor = Colors.green;
        });
      } else {
        setState(() {
          _testResult = '⚠️ Connection issue\n'
              'Status Code: ${e.statusCode}\n'
              'Message: ${e.message}\n'
              'Base URL: ${ApiService.baseUrl}';
          _resultColor = Colors.orange;
        });
      }
    } catch (e) {
      // Network error or connection refused
      setState(() {
        _testResult = '❌ Connection failed!\n\n'
            'Error: $e\n\n'
            'Troubleshooting:\n'
            '1. Check Laravel server is running\n'
            '2. Check Base URL: ${ApiService.baseUrl}\n'
            '3. For Android Emulator: use 10.0.2.2\n'
            '4. For Physical Device: use computer IP\n'
            '5. Check firewall settings\n'
            '6. Ensure same WiFi (for physical device)';
        _resultColor = Colors.red;
      });
    } finally {
      setState(() {
        _isTestingConnection = false;
      });
    }
  }

  Future<void> _testLoginWithDemo() async {
    setState(() {
      _isTestingConnection = true;
      _testResult = 'Testing login with demo account...';
      _resultColor = Colors.blue;
    });

    try {
      final response = await _authService.login(
        email: 'demo@rebox.com',
        password: 'password123',
      );
      
      setState(() {
        _testResult = '✅ Login successful!\n\n'
            'Welcome: ${response['data']['user']['name']}\n'
            'Email: ${response['data']['user']['email']}\n'
            'Token: ${response['data']['token'].toString().substring(0, 20)}...\n\n'
            '🎉 Backend & Frontend connected successfully!';
        _resultColor = Colors.green;
      });

      // Logout after test
      await _authService.logout();
    } on ApiException catch (e) {
      setState(() {
        _testResult = '❌ Login failed\n\n'
            'Status: ${e.statusCode}\n'
            'Message: ${e.message}\n\n';
        
        if (e.statusCode == 401) {
          _testResult += 'Credentials invalid. Did you run seeders?\n'
              'Run: php artisan migrate:fresh --seed';
        }
        
        _resultColor = Colors.red;
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ Connection error\n\n$e';
        _resultColor = Colors.red;
      });
    } finally {
      setState(() {
        _isTestingConnection = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Connection Info',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Base URL: ${ApiService.baseUrl}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Test Buttons
            ElevatedButton.icon(
              onPressed: _isTestingConnection ? null : _testConnection,
              icon: const Icon(Icons.wifi),
              label: const Text('Test Connection'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _isTestingConnection ? null : _testLoginWithDemo,
              icon: const Icon(Icons.login),
              label: const Text('Test Login (Demo Account)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),

            // Result
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _resultColor.withOpacity(0.1),
                  border: Border.all(color: _resultColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: _isTestingConnection
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Testing...'),
                            ],
                          ),
                        )
                      : Text(
                          _testResult.isEmpty
                              ? 'Tap a button above to test connection'
                              : _testResult,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: _resultColor.withOpacity(0.8),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
