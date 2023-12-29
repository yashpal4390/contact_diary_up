// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../provider/theme_provider.dart';

class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ThemeProvider>(context, listen: false).ref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          Consumer<ThemeProvider>(
            builder: (context, Providervalue, child) {
              return ListTile(
                title: Text('Theme Selection'),
                trailing: DropdownButton<ThemeMode>(
                  value:
                      // Provider.of<ThemeProvider>(context, listen: false).theme,
                      Providervalue.theme,
                  onChanged: (ThemeMode? value) async {
                    print("value $value");
                    Providervalue.setTheme(value!);
                    Providervalue.setString(
                        Providervalue.themeModeToString(value));
                  },
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text(
                          "${Provider.of<ThemeProvider>(context, listen: false).text_fun(ThemeMode.light)}"),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text(
                          "${Provider.of<ThemeProvider>(context, listen: false).text_fun(ThemeMode.dark)}"),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text(
                          "${Provider.of<ThemeProvider>(context, listen: false).text_fun(ThemeMode.system)}"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
