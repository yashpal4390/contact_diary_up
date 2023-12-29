import 'package:contact_diary/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode? theme;
  String? prefString;
  String txt = "";
  String? gString;
  static const String keyString = 'thm';

  ThemeProvider(){
    theme=stringToThemeMode(prefs.getString(keyString));
    print("theme ==> $theme");
  }

  //set
  void setString(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyString, value);
  }

  //get
  Future<String?> getString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyString);
  }
  void demo(){
    String? val=prefs.getString(keyString);
    val=gString;
    theme=stringToThemeMode(gString);
    notifyListeners();
  }

  void set() {
    setString(prefString!);
    print(prefString);
  }

  void getStoredString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedValue = prefs.getString(keyString);
    gString = storedValue;
    print("gString $gString");
  }

  void last() {
    theme = stringToThemeMode(gString);
    // print(theme);
    notifyListeners();
  }

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

  void setThemes() {
    theme = stringToThemeMode(gString);
    print(theme);
    print(gString);
    notifyListeners();
  }

  void ref() {
    notifyListeners();
  }

  String? text_fun(ThemeMode t) {
    if (t == ThemeMode.light) {
      txt = "Light Theme";
    } else if (t == ThemeMode.dark) {
      txt = "Dark Theme";
    } else if (t == ThemeMode.system) {
      txt = "System Theme";
    }
    return txt;
  }

  ThemeMode? setThemess() {
    ThemeMode? t = theme;
    return t;
  }
}
