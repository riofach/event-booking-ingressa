import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/entities/user_entity.dart';
import '../../datasources/auth/auth_remote_datasource.dart';
import '../../../domain/repositories/auth/auth_repository.dart';

/// Implementasi repository autentikasi
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  /// Login dengan email dan password
  @override
  Future<User?> signInWithEmail(String email, String password) {
    return remoteDatasource.signInWithEmail(email, password);
  }

  /// Register user baru dengan email dan password
  @override
  Future<User?> registerWithEmail(String email, String password) {
    return remoteDatasource.registerWithEmail(email, password);
  }

  /// Sign out user
  @override
  Future<void> signOut() {
    return remoteDatasource.signOut();
  }

  /// Login dengan Google
  @override
  Future<User?> signInWithGoogle() {
    return remoteDatasource.signInWithGoogle();
  }

  /// Mendapatkan user yang sedang login
  @override
  User? getCurrentUser() {
    return remoteDatasource.getCurrentUser();
  }

  /// Menyimpan data user baru ke Firestore setelah register
  Future<void> createUserInFirestore({
    required String uid,
    required String name,
    required String email,
    String role = 'user',
  }) {
    return remoteDatasource.createUserInFirestore(
      uid: uid,
      name: name,
      email: email,
      role: role,
    );
  }

  /// Mengambil data user lengkap dari Firestore berdasarkan UID
  Future<UserEntity?> getUserFromFirestore(String uid) {
    return remoteDatasource.getUserFromFirestore(uid);
  }

  /// Mengirim email reset password ke user
  Future<void> resetPassword(String email) {
    return remoteDatasource.resetPassword(email);
  }
}
