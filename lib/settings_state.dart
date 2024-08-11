import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState extends ChangeNotifier{
  String _mode = 'system';
  bool _history = true;

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _mode = prefs.getString('darkMode') ?? 'system';
    _history = prefs.getBool('showHistory') ?? true;
    notifyListeners();
  }

  void setHistory(bool history) {
    _history = history;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('showHistory', history);
    });
  }

  bool showHistory() {
    return _history;
  }

  ThemeMode getThemeMode() {
    switch (_mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  bool isLightMode() {
    return _mode == 'light';
  }

  bool isDarkMode() {
    return _mode == 'dark';
  }

  bool isSystemMode() {
    return _mode == 'system';
  }


  void _toogleMode(String mode) {
    _mode = mode;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('darkMode', mode);
    });
  }

  void toggleLightMode() {
    _toogleMode("light");
  }

  void toggleDarkMode() {
    _toogleMode("dark");
  }

  void toggleSystemMode() {
    _toogleMode("system");
  }
}