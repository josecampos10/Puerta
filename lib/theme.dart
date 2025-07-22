import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  
  scaffoldBackgroundColor: Color.fromRGBO(4, 99, 128, 1),
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
      primary: Colors.white,
      secondary: const Color.fromARGB(255, 0, 0, 0),
      tertiary: Color.fromRGBO(4, 99, 128, 1),
      error: Colors.red),
      
  useMaterial3: true,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      TargetPlatform.iOS: PredictiveBackPageTransitionsBuilder()
    },
  ),
);

ThemeData darkMode = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 73, 73, 73),
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
      primary: const Color.fromARGB(255, 95, 95, 95),
      secondary: const Color.fromARGB(255, 255, 255, 255),
      tertiary: const Color.fromARGB(255, 73, 73, 73)),
  useMaterial3: true,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      TargetPlatform.iOS: PredictiveBackPageTransitionsBuilder()
    },
  ),
);
