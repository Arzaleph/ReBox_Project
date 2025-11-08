import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_pti/pengaturan/settings_service.dart';
import 'package:project_pti/pengaturan/screens/pengaturan_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SettingsService.instance.init();
  });

  testWidgets('Tema dan Notifikasi toggle tersimpan di SharedPreferences', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PengaturanScreen(),
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: SettingsService.instance.themeMode,
    ));

    await tester.pumpAndSettle();

    // Temukan Switch for Tema Gelap
    final temaFinder = find.widgetWithText(SwitchListTile, 'Tema Gelap');
    expect(temaFinder, findsOneWidget);

    // Toggle Tema
    await tester.tap(temaFinder);
    await tester.pumpAndSettle();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('isDarkMode'), true);

    // Temukan Switch for Notifikasi
    final notifFinder = find.widgetWithText(SwitchListTile, 'Notifikasi');
    expect(notifFinder, findsOneWidget);

    // Toggle Notifikasi
    await tester.tap(notifFinder);
    await tester.pumpAndSettle();

    prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('notificationsEnabled'), false);
  });
}
