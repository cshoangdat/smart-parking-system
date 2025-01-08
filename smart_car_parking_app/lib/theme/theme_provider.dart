// Copyright 2024 VinCSS JSC. All rights reserved.
//
// Filename: lib/theme/theme_provider.dart
// Author: datht
// Created: 12/07/2024 13:00:00 +07:00

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier{
  bool _isDark = false;
  bool get isDark => _isDark;

  late SharedPreferences storage;

  final lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    background: Colors.grey[300]!,
    primary: Colors.grey[200]!,
    secondary: Colors.grey[100]!,
  )
);

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      background: Colors.black,
      primary: Colors.grey.shade800,
      secondary: Colors.grey.shade700,
    )
);

  changeTheme() async {
    _isDark = !isDark;
    storage = await SharedPreferences.getInstance();
    storage.setBool("isDark", _isDark);
    notifyListeners();
  }

  init() async {
    storage = await SharedPreferences.getInstance();
    _isDark = storage.getBool("isDark") ?? true;
    notifyListeners();
  }
}