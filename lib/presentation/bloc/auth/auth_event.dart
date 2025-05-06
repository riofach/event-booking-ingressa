part of 'auth_bloc.dart';

/// Event dasar untuk AuthBloc
abstract class AuthEvent {}

/// Event untuk login dengan email dan password
class LoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  LoginWithEmailEvent(this.email, this.password);
}

/// Event untuk register dengan email dan password
class RegisterWithEmailEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  RegisterWithEmailEvent(this.name, this.email, this.password);
}

/// Event untuk login dengan Google
class LoginWithGoogleEvent extends AuthEvent {}

/// Event untuk sign out
class SignOutEvent extends AuthEvent {}

/// Event untuk reset password
class ResetPasswordEvent extends AuthEvent {
  final String email;
  ResetPasswordEvent(this.email);
}
