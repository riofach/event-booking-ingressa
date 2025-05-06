import '../../repositories/auth/auth_repository.dart';

/// Usecase untuk reset password user (mengirim email reset password)
class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  /// Mengirim email reset password ke user
  Future<void> call(String email) async {
    await repository.resetPassword(email);
  }
}
