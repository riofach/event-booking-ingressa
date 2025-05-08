import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/datasources/auth/auth_remote_datasource.dart';
import 'data/repositories/auth/auth_repository_impl.dart';
import 'domain/usecases/auth/login_with_email.dart';
import 'domain/usecases/auth/register_with_email.dart';
import 'domain/usecases/auth/login_with_google.dart';
import 'domain/usecases/auth/sign_out.dart';
import 'domain/usecases/auth/reset_password.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/pages/auth/login_page.dart';
import 'core/themes/app_theme.dart';
import 'core/utils/auth_storage.dart';
import 'domain/entities/user_entity.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/splash_screen_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency injection manual
    final authRemoteDatasource = AuthRemoteDatasource();
    final authRepository = AuthRepositoryImpl(
      remoteDatasource: authRemoteDatasource,
    );
    final loginWithEmail = LoginWithEmail(authRepository);
    final registerWithEmail = RegisterWithEmail(authRepository);
    final loginWithGoogle = LoginWithGoogle(authRepository);
    final signOut = SignOut(authRepository);
    final resetPassword = ResetPassword(authRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => AuthBloc(
                loginWithEmail: loginWithEmail,
                registerWithEmail: registerWithEmail,
                loginWithGoogle: loginWithGoogle,
                signOut: signOut,
                resetPassword: resetPassword,
              ),
        ),
      ],
      child: MaterialApp(
        title: 'Ingressa',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreenPage(),
      ),
    );
  }
}

/// Halaman yang mengecek status autentikasi saat aplikasi dibuka
class AuthCheckPage extends StatefulWidget {
  const AuthCheckPage({super.key});

  @override
  State<AuthCheckPage> createState() => _AuthCheckPageState();
}

class _AuthCheckPageState extends State<AuthCheckPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  // Cek apakah user sebelumnya login dengan Remember Me
  Future<void> _checkAuth() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Delay untuk smooth transition

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
      // Tidak ada user yang login dengan Remember Me, arahkan ke Login
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan splash screen atau loading indicator
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
