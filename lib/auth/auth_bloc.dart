import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_repository.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class GoogleSignInRequested extends AuthEvent {}

class AppleSignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated({required this.user});
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      final user = authRepository.user;
      await emit.forEach<User?>(
        authRepository.user,
        onData: (user) {
          if (user != null) {
            return Authenticated(user: user);
          } else {
            return Unauthenticated();
          }
        },
        onError: (error, stackTrace) {
          return AuthError(message: error.toString());
        },
      );
    });

    on<GoogleSignInRequested>((event, emit) async {
      try {
        await authRepository.signInWithGoogle();
        final user = authRepository.getCurrentUser();
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
        emit(Unauthenticated());
      }
    });

    on<AppleSignInRequested>((event, emit) async {
      try {
        await authRepository.signInWithApple();
        final user = authRepository.getCurrentUser();
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
        emit(Unauthenticated());
      }
    });

    on<SignOutRequested>((event, emit) async {
      await authRepository.signOut();
      emit(Unauthenticated());
    });
  }
}
