import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _signInWithGoogle() {
      context.read<AuthBloc>().add(GoogleSignInRequested());
    }

    void _signInWithApple() {
      context.read<AuthBloc>().add(AppleSignInRequested());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            print(state.message);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _signInWithGoogle,
                child: const Text('Sign in with Google'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signInWithApple,
                child: const Text('Sign in with Apple'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
