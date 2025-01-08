// Copyright 2024 VinCSS JSC. All rights reserved.
//
// Filename: lib/main.dart
// Author: datht
// Created: 12/07/2024 13:00:00 +07:00

import 'package:flutter/material.dart';
import 'package:smart_car_parking_app/my_app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.delayed(const Duration(seconds: 3));

  // FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(
    const MyApp()
  );
}