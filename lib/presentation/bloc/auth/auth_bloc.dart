import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth/login_with_email.dart';
import '../../../domain/usecases/auth/register_with_email.dart';
import '../../../domain/usecases/auth/login_with_google.dart';
import '../../../domain/usecases/auth/sign_out.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/auth/reset_password.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC untuk autentikasi user (login, register, sign out, dsb)
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmail loginWithEmail;
  final RegisterWithEmail registerWithEmail;
  final LoginWithGoogle loginWithGoogle;
  final SignOut signOut;
  final ResetPassword resetPassword;

  AuthBloc({
    required this.loginWithEmail,
    required this.registerWithEmail,
    required this.loginWithGoogle,
    required this.signOut,
    required this.resetPassword,
  }) : super(AuthInitial()) {
    // Event: Login dengan email
    on<LoginWithEmailEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginWithEmail(event.email, event.password);
        if (user != null) {
          // Ambil data lengkap dari Firestore
          final userEntity = await registerWithEmail.repository
              .getUserFromFirestore(user.id);
          if (userEntity != null) {
            emit(AuthSuccess(userEntity));
          } else {
            emit(AuthFailure('Data user tidak ditemukan di Firestore'));
          }
        } else {
          emit(AuthFailure('Login gagal'));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // Event: Register dengan email
    on<RegisterWithEmailEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await registerWithEmail(
          event.name,
          event.email,
          event.password,
        );
        if (user != null) {
          // Ambil data lengkap dari Firestore
          final userEntity = await registerWithEmail.repository
              .getUserFromFirestore(user.id);
          if (userEntity != null) {
            emit(AuthSuccess(userEntity));
          } else {
            emit(AuthFailure('Data user tidak ditemukan di Firestore'));
          }
        } else {
          emit(AuthFailure('Registrasi gagal'));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // Event: Login dengan Google
    on<LoginWithGoogleEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginWithGoogle();
        if (user != null) {
          // Ambil data lengkap dari Firestore
          final userEntity = await registerWithEmail.repository
              .getUserFromFirestore(user.id);
          if (userEntity != null) {
            emit(AuthSuccess(userEntity));
          } else {
            emit(AuthFailure('Data user tidak ditemukan di Firestore'));
          }
        } else {
          emit(AuthFailure('Login Google gagal'));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // Event: Sign out
    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await signOut();
        emit(AuthSignedOut());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // Event: Reset Password
    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await resetPassword(event.email);
        emit(AuthResetPasswordSuccess());
      } catch (e) {
        emit(AuthResetPasswordFailure(e.toString()));
      }
    });
  }
}
