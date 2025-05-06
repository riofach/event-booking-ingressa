import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import 'register_page.dart';
import '../home_page.dart';
import '../../../core/utils/firebase_error_mapper.dart';

/// Halaman Login User
/// Field: Email, Password, tombol Login, Login with Google, Daftar, Lupa Password
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  /// Fungsi untuk handle lupa password (reset password)
  void _onForgotPassword() {
    showDialog(
      context: context,
      builder: (context) {
        final emailController = TextEditingController();
        return AlertDialog(
          title: const Text('Reset Password'),
          content: TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                if (email.isEmpty ||
                    !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Masukkan email valid!')),
                  );
                  return;
                }
                context.read<AuthBloc>().add(ResetPasswordEvent(email));
                Navigator.pop(context);
              },
              child: const Text('Kirim Link'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }
          if (state is AuthSuccess) {
            final user = state.user;
            // Navigasi langsung ke HomePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomePage(user: user)),
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
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Field Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
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
                  const SizedBox(height: 16),

                  /// Field Password
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator:
                        (value) =>
                            value != null && value.length < 6
                                ? 'Minimal 6 karakter'
                                : null,
                  ),
                  const SizedBox(height: 24),

                  /// Tombol Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onLogin,
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Tombol Login with Google
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Image.asset(
                        'assets/images/google_logo.png',
                        width: 20,
                        height: 20,
                      ),
                      label: const Text('Login with Google'),
                      onPressed: _isLoading ? null : _onLoginWithGoogle,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Tombol Daftar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Belum punya akun?'),
                      TextButton(
                        onPressed: _onNavigateToRegister,
                        child: const Text('Daftar'),
                      ),
                    ],
                  ),

                  /// Tombol Lupa Password
                  TextButton(
                    onPressed: _onForgotPassword,
                    child: const Text('Lupa Password?'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
