import 'package:flutter/material.dart';

final ThemeData adminTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF005A9C), // Azul corporativo
    brightness: Brightness.dark,
    primary: const Color(
      0xFF007BFF,
    ), // Azul mais claro para contraste no modo escuro
    secondary: const Color(0xFF0056b3),
    surface: const Color(0xFF121212), // Fundo escuro padrão
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white70,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(
    0xFF1F1F1F,
  ), // Um pouco mais claro que o surface
  cardColor: const Color(0xFF2A2A2A), // Cor dos cards
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF003D6B), // Azul corporativo escuro
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF007BFF),
      foregroundColor: Colors.white,
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
);
