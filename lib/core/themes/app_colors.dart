import 'package:flutter/material.dart';

class AppColors {
  // Primary color shades (500 - 950)
  static const primary500 = Color(0xFFF4909B);
  static const primary600 = Color(0xFFF27887);
  static const primary700 = Color(0xFFF06676);
  static const primary800 = Color(0xFFEE5365);
  static const primary900 = Color(0xFFEC3C50);
  static const primary950 = Color(0xFFEB3349);

  // Secondary color shades (500 - 950)
  static const secondary500 = Color(0xFFF9A79A);
  static const secondary600 = Color(0xFFF89687);
  static const secondary700 = Color(0xFFF78573);
  static const secondary800 = Color(0xFFF67460);
  static const secondary900 = Color(0xFFF5634D);
  static const secondary950 = Color(0xFFF45C43);

  // Gradient styles
  static const _gradientColors = [primary950, secondary950];

  // Vertical 01: primary atas, secondary bawah
  static LinearGradient get vertical01 => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: _gradientColors,
  );

  // Vertical 02: secondary atas, primary bawah
  static LinearGradient get vertical02 => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [secondary950, primary950],
  );

  // Horizontal 01: primary kiri, secondary kanan
  static LinearGradient get horizontal01 => const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: _gradientColors,
  );

  // Horizontal 02: secondary kiri, primary kanan
  static LinearGradient get horizontal02 => const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [secondary950, primary950],
  );

  // Diagonal 01: primary kiri atas, secondary kanan bawah
  static LinearGradient get diagonal01 => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: _gradientColors,
  );

  // Diagonal 02: secondary kiri atas, primary kanan bawah
  static LinearGradient get diagonal02 => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary950, primary950],
  );

  // Dark Color Shades
  static const dark800 = Color(0xFF552211);
  static const dark900 = Color(0xFF2F1309);
  static const dark950 = Color(0xFF190A05);

  // White Color Shades
  static const white900 = Color(0xFFFFFFFF);
  static const white950 = Color(0xFFFAFAFA);

  // Gray Color Shades
  static const gray600 = Color(0xFFD5D5DD);
  static const gray700 = Color(0xFFC7C7D1);
  static const gray800 = Color(0xFFB4B4C1);
  static const gray900 = Color(0xFF9B9BAC);
  static const gray950 = Color(0xFF7A7A90);

  // Cara pakai warna solid
  // color: AppColors.primary700

  // Cara pakai warna gradient
  //   Container(
  //   decoration: BoxDecoration(
  //     gradient: AppColors.vertical01,
  //   ),
  // )
}
