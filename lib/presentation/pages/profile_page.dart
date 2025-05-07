import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';

/// Halaman Profile User
class ProfilePage extends StatelessWidget {
  final UserEntity user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gambar profile default dari shadcn
              CircleAvatar(
                radius: 48,
                backgroundImage: const NetworkImage(
                  'https://github.com/shadcn.png',
                ),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 24),
              // Nama
              Text(
                user.name.isNotEmpty ? user.name : '-',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Email
              Text(
                user.email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              // Role
              Chip(
                label: Text(
                  user.role.isNotEmpty ? user.role : '-',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.deepPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
