import '../../repositories/auth/auth_repository.dart';

/// Usecase untuk sign out user
class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  /// Melakukan sign out user
  Future<void> call() async {
    await repository.signOut();
  }
}
