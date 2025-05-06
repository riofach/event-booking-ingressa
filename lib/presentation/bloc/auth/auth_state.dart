part of 'auth_bloc.dart';

/// State dasar untuk AuthBloc
abstract class AuthState {}

/// State awal (belum ada aksi autentikasi)
class AuthInitial extends AuthState {}

/// State loading (proses autentikasi sedang berjalan)
class AuthLoading extends AuthState {}

/// State sukses autentikasi (login/register berhasil)
class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess(this.user);
}

/// State gagal autentikasi (login/register gagal)
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

/// State user sudah sign out
class AuthSignedOut extends AuthState {}

/// State sukses reset password
class AuthResetPasswordSuccess extends AuthState {}

/// State gagal reset password
class AuthResetPasswordFailure extends AuthState {
  final String message;
  AuthResetPasswordFailure(this.message);
}
