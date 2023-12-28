import 'dart:convert';

import 'package:contact_diary/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode theme = ThemeMode.system;
  String? prefString;

  void setTheme(ThemeMode th) {
    theme = th;
    notifyListeners();
  }

  void ThemeModetoString() {
    prefString = theme as String?;
    print("This is Theme");
    print(prefString);
    notifyListeners();
  }

  Future<void> setPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', prefString!);
  }

  String themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'ThemeMode.light';
      case ThemeMode.dark:
        return 'ThemeMode.dark';
      case ThemeMode.system:
        return 'ThemeMode.system';
    }
  }
  ThemeMode stringToThemeMode(String? themeString) {
    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
        return ThemeMode.system;
      default:
        throw Exception('Unknown theme mode: $themeString');
    }
  }
  void Merge(){
    theme=stringToThemeMode(prefString!);
    notifyListeners();
  }
  ThemeMode setThemes(){
    print(prefString);
    theme=stringToThemeMode(prefString);
    notifyListeners();
    return theme;
  }
}
