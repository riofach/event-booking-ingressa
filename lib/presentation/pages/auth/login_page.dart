import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import 'register_page.dart';
import '../home_page.dart';
import '../../../core/utils/firebase_error_mapper.dart';
import '../../widgets/primary_button.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/utils/page_transition.dart';
import 'forgot_password_page.dart';
import '../../../core/utils/auth_storage.dart';

/// Halaman Login User sesuai desain Figma
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  /// Load saved email and check remember me status
  Future<void> _loadSavedCredentials() async {
    // Load remember me status
    final isRemembered = await AuthStorage.isRememberMeEnabled();

    if (isRemembered) {
      final savedEmail = await AuthStorage.getSavedEmail();
      if (savedEmail != null) {
        setState(() {
          _emailController.text = savedEmail;
          _rememberMe = true;
        });
      }

      // Auto login ditangani oleh AuthCheckPage
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Fungsi untuk handle login email/password
  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      context.read<AuthBloc>().add(
        LoginWithEmailEvent(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        ),
      );
    }
  }

  /// Fungsi untuk handle login dengan Google
  void _onLoginWithGoogle() {
    setState(() => _isLoading = true);
    context.read<AuthBloc>().add(LoginWithGoogleEvent());
  }

  /// Fungsi untuk handle navigasi ke register
  void _onNavigateToRegister() {
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition.slideRight(
        page: const RegisterPage(),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuad,
      ),
      (route) => false,
    );
  }

  /// Fungsi untuk handle lupa password (reset password)
  void _onForgotPassword() {
    Navigator.push(
      context,
      PageTransition.fadeScale(
        page: const ForgotPasswordPage(),
        duration: const Duration(milliseconds: 400),
        beginScale: 0.95,
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.dark900) : null,
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
      hintStyle: const TextStyle(
        fontFamily: 'NunitoSans',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColors.gray700,
        height: 1.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white950,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }
          if (state is AuthSuccess) {
            final user = state.user;

            // Simpan data user jika remember me aktif
            if (_rememberMe) {
              // Convert user data ke Map untuk disimpan
              Map<String, dynamic> userData = {
                'uid': user.id,
                'email': user.email,
                'name': user.name,
                'role': user.role,
                // Tambahkan field lain sesuai kebutuhan
              };

              AuthStorage.saveUserCredentials(
                email: _emailController.text.trim(),
                isRemembered: _rememberMe,
                userData: userData,
              );
            } else {
              // Hapus data jika remember me tidak aktif
              AuthStorage.clearUserCredentials();
            }

            Navigator.pushReplacement(
              context,
              PageTransition.fadeScale(
                page: HomePage(user: user),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutQuad,
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(content: Text(mapFirebaseAuthError(state.message))),
              );
          } else if (state is AuthResetPasswordSuccess) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(
                  content: Text(
                    'Link reset password telah dikirim ke email Anda.',
                  ),
                ),
              );
          } else if (state is AuthResetPasswordFailure) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(content: Text(mapFirebaseAuthError(state.message))),
              );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Judul
                  Text(
                    'Sign in to\nyour account',
                    style: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                      color: AppColors.dark900,
                      height: 1.33,
                    ),
                  ),

                  /// Sudah punya akun? Sign Up
                  Row(
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.dark900,
                        ),
                      ),
                      TextButton(
                        onPressed: _onNavigateToRegister,
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.primary950,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  /// Field Email
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration(
                      hint: 'Enter your email',
                      icon: Icons.email,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  /// Field Password
                  TextFormField(
                    controller: _passwordController,
                    decoration: _inputDecoration(
                      hint: 'Enter your password',
                      icon: Icons.lock,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.secondary950,
                        ),
                        onPressed:
                            () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator:
                        (value) =>
                            value != null && value.length < 6
                                ? 'Minimal 6 karakter'
                                : null,
                  ),
                  const SizedBox(height: 16),

                  /// Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged:
                                (val) =>
                                    setState(() => _rememberMe = val ?? false),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            activeColor: AppColors.primary950,
                          ),
                          const Text(
                            'Remember me',
                            style: TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.dark900,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _onForgotPassword,
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.primary950,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  /// Tombol Sign In
                  PrimaryButton(
                    text: 'Sign In',
                    onPressed: _isLoading ? () {} : _onLogin,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),

                  /// Atau sign in dengan
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.gray800)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'or sign in with',
                          style: TextStyle(
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.gray800,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.gray800)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// Tombol Google
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Image.asset(
                        'assets/images/google_logo.png',
                        width: 30,
                        height: 30,
                      ),
                      label: const Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.dark900,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.gray800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: AppColors.white900,
                      ),
                      onPressed: _isLoading ? null : _onLoginWithGoogle,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
