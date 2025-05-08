import '../../repositories/auth/auth_repository.dart';
import '../../../core/utils/auth_storage.dart';

/// Usecase untuk sign out user
class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  /// Melakukan sign out user dan membersihkan data Remember Me
  Future<void> call() async {
    // Hapus data credential di local storage
    await AuthStorage.clearUserCredentials();

    // Sign out dari Firebase
    await repository.signOut();
  }
}
