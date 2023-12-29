import 'package:contact_diary/provider/contact_provider.dart';
import 'package:contact_diary/provider/theme_provider.dart';
import 'package:contact_diary/view/home_page.dart';
import 'package:contact_diary/view/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
ThemeMode? th;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ContactProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        )
      ],
      builder: (context, child) {
        return Consumer<ThemeProvider>(
          builder: (BuildContext context, Themeprovidervalue, Widget? child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: HomePage(),
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: Themeprovidervalue.theme,
            );
          },
        );
      },
    );
  }
}
