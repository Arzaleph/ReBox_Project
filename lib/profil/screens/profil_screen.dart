// Basic profile screen with edit/save and logout
import 'package:flutter/material.dart';
import 'package:project_pti/profil/profile_service.dart';
import 'package:project_pti/pengaturan/settings_service.dart';
import 'package:project_pti/profil/widgets/profile_header.dart';
import 'package:project_pti/core/api.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _avatarCtrl = TextEditingController();

  bool _editing = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initProfile();
  }

  Future<void> _initProfile() async {
    await ProfileService.instance.init();
    if (!mounted) return;
    final p = ProfileService.instance;
    _nameCtrl.text = p.name;
    _emailCtrl.text = p.email;
    _phoneCtrl.text = p.phone;
    _avatarCtrl.text = p.avatarUrl;
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _avatarCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _loading = true);
    await ProfileService.instance.setName(_nameCtrl.text.trim());
    await ProfileService.instance.setEmail(_emailCtrl.text.trim());
    await ProfileService.instance.setPhone(_phoneCtrl.text.trim());
    await ProfileService.instance.setAvatarUrl(_avatarCtrl.text.trim());
    // attempt to push to remote if configured
    String? remoteError;
    if (ApiConfig.baseUrl.isNotEmpty) {
      try {
        await ProfileService.instance.syncToRemote();
      } catch (e) {
        remoteError = e.toString();
      }
    }
    if (!mounted) return;
    setState(() {
      _editing = false;
      _loading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(remoteError == null ? 'Profil disimpan' : 'Disimpan lokal (sinkron gagal)')));
    if (remoteError != null) {
      // show detailed banner
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sinkron ke server gagal: $remoteError')));
    }
  }

  Future<void> _logout() async {
    setState(() => _loading = true);
    // clear profile and auth token
    await ProfileService.instance.clearProfile();
    await SettingsService.instance.logout();
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Anda telah logout')));
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ProfileService.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          if (!_editing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _editing = true),
            )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  ProfileHeader(name: profile.name, avatarUrl: profile.avatarUrl),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nama'),
                    enabled: _editing,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    enabled: _editing,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Telepon'),
                    keyboardType: TextInputType.phone,
                    enabled: _editing,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _avatarCtrl,
                    decoration: const InputDecoration(labelText: 'URL Avatar (opsional)'),
                    keyboardType: TextInputType.url,
                    enabled: _editing,
                  ),
                  const SizedBox(height: 16),
                  if (_editing)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text('Simpan'),
                            onPressed: _saveProfile,
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          child: const Text('Batal'),
                          onPressed: () {
                            // revert controllers to stored values
                            _nameCtrl.text = profile.name;
                            _emailCtrl.text = profile.email;
                            _phoneCtrl.text = profile.phone;
                            _avatarCtrl.text = profile.avatarUrl;
                            setState(() => _editing = false);
                          },
                        ),
                      ],
                    )
                  else
                    ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      onPressed: _logout,
                    ),
                ],
              ),
            ),
    );
  }
}