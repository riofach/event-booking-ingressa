import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import 'login_page.dart';
import '../home_page.dart';
import '../../../core/utils/firebase_error_mapper.dart';

/// Halaman Register User
/// Field: Nama, Email, Password, Konfirmasi Password
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
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
            // Tampilkan snackbar di HomePage jika ingin, atau di sini tanpa blocking
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
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Field Nama
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Nama wajib diisi'
                                : null,
                  ),
                  const SizedBox(height: 16),

                  /// Field Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email wajib diisi';
                      }
                      // Regex email sederhana
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
                  const SizedBox(height: 16),

                  /// Field Konfirmasi Password
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Konfirmasi Password',
                    ),
                    obscureText: true,
                    validator:
                        (value) =>
                            value != _passwordController.text
                                ? 'Password tidak sama'
                                : null,
                  ),
                  const SizedBox(height: 24),

                  /// Tombol Register
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onRegister,
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text('Daftar'),
                    ),
                  ),

                  /// Tombol Login jika sudah punya akun
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sudah punya akun?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text('Login'),
                      ),
                    ],
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
