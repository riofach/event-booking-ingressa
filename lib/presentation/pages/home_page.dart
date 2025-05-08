import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth/auth_bloc.dart';
import 'auth/login_page.dart';
import 'profile_page.dart';
import '../../core/utils/auth_storage.dart';

/// Halaman Home sederhana yang menampilkan nama dan role user yang login
class HomePage extends StatelessWidget {
  final UserEntity user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignedOut) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Profil Saya',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfilePage(user: user)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sign Out',
              onPressed: () {
                AuthStorage.clearUserCredentials();
                context.read<AuthBloc>().add(SignOutEvent());
              },
            ),
          ],
        ),
        body: Center(
          child: Text(
            'Selamat Datang ${user.name} sebagai ${user.role}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
