import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/themes/app_colors.dart';
import '../../core/utils/auth_storage.dart';
import '../../domain/entities/user_entity.dart';
import 'auth/login_page.dart';
import 'home_page.dart';
import 'onboarding_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    // Cek autentikasi setelah delay untuk efek splash screen
    Timer(const Duration(seconds: 3), () {
      _checkAuth();
    });
  }

  // Cek apakah user sebelumnya login dengan Remember Me
  Future<void> _checkAuth() async {
    final userData = await AuthStorage.getSavedUserData();
    if (userData != null) {
      // User data ada di SharedPreferences, konversi ke UserEntity
      final user = UserEntity.fromMap(userData);

      // Langsung arahkan ke HomePage
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(user: user)),
        );
      }
    } else {
      // Tidak ada user yang login dengan Remember Me, arahkan ke Onboarding
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.vertical01),
        child: Center(
          child: Image.asset(
            'assets/images/logo-ingressa.png',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
