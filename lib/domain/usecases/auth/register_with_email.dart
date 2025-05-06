import '../../repositories/auth/auth_repository.dart';
import '../../entities/user_entity.dart';

/// Usecase untuk register user baru dengan email dan password
class RegisterWithEmail {
  final AuthRepository repository;

  RegisterWithEmail(this.repository);

  /// Melakukan registrasi dan mengembalikan UserEntity jika berhasil
  Future<UserEntity?> call(String name, String email, String password) async {
    final user = await repository.registerWithEmail(email, password);
    if (user == null) return null;
    // Simpan data user ke Firestore (role default: user)
    await repository.createUserInFirestore(
      uid: user.uid,
      name: name,
      email: user.email ?? '',
      role: 'user',
    );
    return UserEntity(
      id: user.uid,
      name: name,
      email: user.email ?? '',
      role: 'user',
      createdAt: user.metadata.creationTime,
    );
  }
}
