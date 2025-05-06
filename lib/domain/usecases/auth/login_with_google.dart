import '../../repositories/auth/auth_repository.dart';
import '../../entities/user_entity.dart';

/// Usecase untuk login dengan Google
class LoginWithGoogle {
  final AuthRepository repository;

  LoginWithGoogle(this.repository);

  /// Melakukan login Google dan mengembalikan UserEntity jika berhasil
  Future<UserEntity?> call() async {
    final user = await repository.signInWithGoogle();
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
