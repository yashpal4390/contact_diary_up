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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Theme Selection'),
            trailing: DropdownButton<ThemeMode>(
              value: Provider.of<ThemeProvider>(context, listen: false).theme,
              onChanged: (ThemeMode? value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .setTheme(value!);
                Provider.of<ThemeProvider>(context, listen: false)
                    .prefString= Provider.of<ThemeProvider>(context, listen: false).themeModeToString(value);
                print("${Provider.of<ThemeProvider>(context,listen: false).prefString}");
                Provider.of<ThemeProvider>(context, listen: false).Merge();
              },
              items: [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
