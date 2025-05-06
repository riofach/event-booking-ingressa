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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        // home: const Scaffold(
        //   body: Center(
        //     child: Text('Hello, Ingressa!'),
        //   ), // Widget sederhana untuk testing
        // ),
        home: const LoginPage(),
      ),
    );
  }
}
