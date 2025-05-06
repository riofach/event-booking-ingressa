import '../../repositories/auth/auth_repository.dart';
import '../../entities/user_entity.dart';

/// Usecase untuk login dengan email dan password
class LoginWithEmail {
  final AuthRepository repository;

  LoginWithEmail(this.repository);

  /// Melakukan login dan mengembalikan UserEntity jika berhasil
  Future<UserEntity?> call(String email, String password) async {
    final user = await repository.signInWithEmail(email, password);
    if (user == null) return null;
    return UserEntity(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      role: '', // Role diambil dari Firestore, bisa diisi nanti
      createdAt: user.metadata.creationTime,
    );
  }
}
