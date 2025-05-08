import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password_success_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _hasInput = false;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onConfirm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        setState(() => _isLoading = false);

        // Navigate to success page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ForgotPasswordSuccessPage()),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim email reset: \\n${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white950,
      appBar: AppBar(
        backgroundColor: AppColors.white950,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.dark900),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Icon Email dalam lingkaran gradient
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/Icons-forgot-password.png',
                    width: 62,
                    height: 62,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),

                /// Judul
                const Text(
                  'Forgot Your Password?',
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: AppColors.dark900,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                /// Deskripsi
                const Text(
                  'Please enter your email address account to send link verification to reset your password',
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

                /// Input Email
                TextFormField(
                  controller: _emailController,
                  onChanged:
                      (val) => setState(() => _hasInput = val.isNotEmpty),
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(
                      Icons.email,
                      color: AppColors.dark900,
                    ),
                    filled: true,
                    fillColor: AppColors.white950,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            _isFocused
                                ? AppColors.secondary950
                                : (_hasInput
                                    ? AppColors.secondary950
                                    : AppColors.gray600),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            _isFocused
                                ? AppColors.secondary950
                                : (_hasInput
                                    ? AppColors.secondary950
                                    : AppColors.gray600),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.secondary950,
                        width: 1.5,
                      ),
                    ),
                    hintStyle: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.gray700,
                      height: 1.5,
                    ),
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
                const SizedBox(height: 32),

                /// Tombol Confirm
                PrimaryButton(
                  text: 'Confirm',
                  onPressed: _isLoading ? () {} : _onConfirm,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),
                // Tombol testing ke halaman sukses
                // OutlinedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) => const ForgotPasswordSuccessPage(),
                //       ),
                //     );
                //   },
                //   child: const Text('Test Success Page'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
