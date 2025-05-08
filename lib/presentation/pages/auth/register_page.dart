import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/page_transition.dart';
import '../../bloc/auth/auth_bloc.dart';
import 'login_page.dart';
import '../home_page.dart';
import '../../../core/utils/firebase_error_mapper.dart';
import '../../widgets/primary_button.dart';
import '../../../core/themes/app_colors.dart';

/// Halaman Register User sesuai desain Figma
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Fungsi untuk handle register (dispatch ke AuthBloc)
  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      context.read<AuthBloc>().add(
        RegisterWithEmailEvent(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        ),
      );
    }
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
        borderSide: BorderSide(color: AppColors.primary950, width: 1.5),
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Nunito Sans',
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
            Navigator.pushReplacement(
              context,
              PageTransition.fadeScale(
                page: HomePage(user: user),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutQuad,
              ),
            );
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(content: Text('Registrasi berhasil!')),
              );
          } else if (state is AuthFailure) {
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
                    'Create new\naccount',
                    style: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                      color: AppColors.dark900,
                      height: 1.33,
                    ),
                  ),

                  /// Sudah punya akun? Login
                  Row(
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.dark900,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition.slideLeft(
                              page: const LoginPage(),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutQuad,
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          'Sign In',
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

                  /// Field Nama
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration(
                      hint: 'Enter your username',
                      icon: Icons.person,
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Nama wajib diisi'
                                : null,
                  ),
                  const SizedBox(height: 24),

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
                      hint: 'Password',
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
                  const SizedBox(height: 24),

                  /// Field Konfirmasi Password
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: _inputDecoration(
                      hint: 'Confirmation Password',
                      icon: Icons.lock,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.secondary950,
                        ),
                        onPressed:
                            () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                      ),
                    ),
                    obscureText: _obscureConfirm,
                    validator:
                        (value) =>
                            value != _passwordController.text
                                ? 'Password tidak sama'
                                : null,
                  ),
                  const SizedBox(height: 32),

                  /// Tombol Sign Up
                  PrimaryButton(
                    text: 'Sign Up',
                    onPressed: _isLoading ? () {} : _onRegister,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),

                  /// Agreement
                  Center(
                    child: Text(
                      'By clicking "Sign Up" you agree to Recognotes Term of Use and Privacy Policy',
                      style: const TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.gray900,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
