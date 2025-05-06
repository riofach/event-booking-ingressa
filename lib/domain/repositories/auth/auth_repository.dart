import 'package:firebase_auth/firebase_auth.dart';
import '../../entities/user_entity.dart';

/// Abstraksi repository autentikasi
abstract class AuthRepository {
  /// Login dengan email dan password
  Future<User?> signInWithEmail(String email, String password);

  /// Register user baru dengan email dan password
  Future<User?> registerWithEmail(String email, String password);

  /// Sign out user
  Future<void> signOut();

  /// Login dengan Google
  Future<User?> signInWithGoogle();

  /// Mendapatkan user yang sedang login
  User? getCurrentUser();

  /// Menyimpan data user baru ke Firestore setelah register
  Future<void> createUserInFirestore({
    required String uid,
    required String name,
    required String email,
    String role,
  });

  /// Mengambil data user lengkap dari Firestore berdasarkan UID
  Future<UserEntity?> getUserFromFirestore(String uid);

  /// Mengirim email reset password ke user
  Future<void> resetPassword(String email);
}
