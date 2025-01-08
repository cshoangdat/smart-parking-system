import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smart_car_parking_app/screen/home_screen.dart';
import 'package:smart_car_parking_app/screen/register_screen.dart';
import 'package:smart_car_parking_app/theme/theme_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
         designSize: const Size(384, 832),
          minTextAdapt: true,
          splitScreenMode: true,
         builder: (_ , child) {
            return ChangeNotifierProvider(
              create: (BuildContext context) => ThemeProvider()..init(),
              child: Consumer<ThemeProvider>(
                builder: (context, ThemeProvider notifier, child){
                  return MaterialApp(
                    title: 'Smart Car Parking',
                    themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
                    theme: notifier.isDark ? notifier.darkTheme : notifier.lightTheme,
                    // home: currentPage,
                    debugShowCheckedModeBanner: false,
                    // navigatorObservers: [BluetoothAdapterStateObserver()],
                    routes: {
                      '/' : (context) => const HomeScreen(),
                    },
                  );
                }
              ),
            );
         }
      );
  }
}