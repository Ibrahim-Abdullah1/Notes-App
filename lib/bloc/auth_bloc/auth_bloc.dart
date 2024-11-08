import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/bloc/auth_bloc/auth_event.dart';
import 'package:notes_app/bloc/auth_bloc/auth_state.dart';
import '../../data/repository/auth_repository.dart';

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
