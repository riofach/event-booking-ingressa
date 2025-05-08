import 'package:flutter/material.dart';

/// Kelas utilitas untuk transisi halaman di aplikasi Ingressa
/// Berisi berbagai jenis animasi untuk perpindahan antar halaman
///
/// Cara Pakai:
/// Navigator.push(
///   context,
///   PageTransition.fade(
///     page: const NewPage(),
///   ),
/// );
class PageTransition {
  /// Transisi fade sederhana (memudar)
  static Route<T> fade<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
        return FadeTransition(opacity: animation.drive(tween), child: child);
      },
    );
  }

  /// Transisi slide (geser) dari arah tertentu
  static Route<T> slide<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    Offset startOffset = const Offset(1.0, 0.0), // Default dari kanan
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(
          begin: startOffset,
          end: Offset.zero,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Transisi slide dari kiri
  static Route<T> slideLeft<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return slide<T>(
      page: page,
      duration: duration,
      curve: curve,
      startOffset: const Offset(-1.0, 0.0),
    );
  }

  /// Transisi slide dari kanan
  static Route<T> slideRight<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return slide<T>(
      page: page,
      duration: duration,
      curve: curve,
      startOffset: const Offset(1.0, 0.0),
    );
  }

  /// Transisi slide dari atas
  static Route<T> slideUp<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return slide<T>(
      page: page,
      duration: duration,
      curve: curve,
      startOffset: const Offset(0.0, -1.0),
    );
  }

  /// Transisi slide dari bawah
  static Route<T> slideDown<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return slide<T>(
      page: page,
      duration: duration,
      curve: curve,
      startOffset: const Offset(0.0, 1.0),
    );
  }

  /// Transisi skala (zoom in/out)
  static Route<T> scale<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    double begin = 0.0,
    double end = 1.0,
    Alignment alignment = Alignment.center,
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return ScaleTransition(
          scale: animation.drive(tween),
          alignment: alignment,
          child: child,
        );
      },
    );
  }

  /// Transisi rotasi
  static Route<T> rotate<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    double begin = 0.0,
    double end = 1.0,
    Alignment alignment = Alignment.center,
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(
          begin: begin * 3.14,
          end: end * 3.14,
        ).chain(CurveTween(curve: curve));
        return RotationTransition(
          turns: animation.drive(tween),
          alignment: alignment,
          child: child,
        );
      },
    );
  }

  /// Transisi kombinasi fade dan slide
  static Route<T> fadeSlide<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    Offset startOffset = const Offset(0.0, 0.1),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeAnimation = Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: curve)).animate(animation);
        var slideAnimation = Tween(
          begin: startOffset,
          end: Offset.zero,
        ).chain(CurveTween(curve: curve)).animate(animation);

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(position: slideAnimation, child: child),
        );
      },
    );
  }

  /// Transisi kombinasi fade dan scale
  static Route<T> fadeScale<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    double beginScale = 0.9,
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeAnimation = Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: curve)).animate(animation);
        var scaleAnimation = Tween(
          begin: beginScale,
          end: 1.0,
        ).chain(CurveTween(curve: curve)).animate(animation);

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
    );
  }

  /// Transisi page curl like iOS (3D)
  static Route<T> curlUp<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 600),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
