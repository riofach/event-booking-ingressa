import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/utils/page_transition.dart';
import 'login_page.dart';

class ForgotPasswordSuccessPage extends StatefulWidget {
  const ForgotPasswordSuccessPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordSuccessPage> createState() =>
      _ForgotPasswordSuccessPageState();
}

class _ForgotPasswordSuccessPageState extends State<ForgotPasswordSuccessPage> {
  int _secondsRemaining = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          _navigateToLogin();
        }
      });
    });
  }

  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition.scale(
        page: const LoginPage(),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuad,
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white950,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Illustration
                Image.asset(
                  'assets/images/reset_password_success.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),

                // Title
                const Text(
                  'Check Your Email!',
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.dark900,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Description
                const Text(
                  'Please login to app again\nwith your new password',
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.dark900,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Countdown
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.dark900,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'Back to login '),
                      TextSpan(
                        text: '$_secondsRemaining',
                        style: const TextStyle(
                          color: AppColors.primary950,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: ' second${_secondsRemaining == 1 ? '' : 's'}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
