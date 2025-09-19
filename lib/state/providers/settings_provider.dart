// lib/state/providers/settings_provider.dart
import 'package:flutter/material.dart';
// TODO: sambungkan ke SharedPreferences bila perlu

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _language = 'id';
  bool _notificationsEnabled = true;

  // getters
  bool get isDark => _themeMode == ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;

  // init / load
  Future<void> load() async {
    // TODO: load dari SharedPreferences
    // contoh default sudah terpasang
    notifyListeners();
  }

  // setters
  void setDarkMode(bool enabled) {
    _themeMode = enabled ? ThemeMode.dark : ThemeMode.light;
    // TODO: simpan ke prefs
    notifyListeners();
  }

  void setLanguage(String code) {
    _language = code;
    // TODO: simpan ke prefs + trigger i18n
    notifyListeners();
  }

  void setNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    // TODO: simpan ke prefs
    notifyListeners();
  }
}
