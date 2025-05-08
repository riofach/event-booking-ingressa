import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    fontFamily: 'NunitoSans',
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.dark900),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'NunitoSans',
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'NunitoSans',
        fontWeight: FontWeight.w400,
      ),
      titleLarge: TextStyle(
        fontFamily: 'NunitoSans',
        fontWeight: FontWeight.w700,
      ),
      // Tambahkan style lain sesuai kebutuhan
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(
        fontFamily: 'NunitoSans',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColors.gray700,
        height: 1.5,
      ),
      labelStyle: const TextStyle(
        fontFamily: 'NunitoSans',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColors.gray700,
        height: 1.5,
      ),
      filled: true,
      fillColor: AppColors.white950,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.gray600),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.gray600),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary950, width: 1.5),
      ),
    ),
    // ...tambahkan pengaturan lain (button, appbar, dsb)
  );
}

// cara pakai liat jenis text di pubspec.yaml
// Text(
//   'Ini custom bold merah',
//   style: const TextStyle(
//     fontFamily: 'NunitoSans',
//     fontWeight: FontWeight.w800,
//     fontSize: 20,
//     color: AppColors.primary950,
//   ),
// )
