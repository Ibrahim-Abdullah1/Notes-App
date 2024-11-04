import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/auth/auth_bloc.dart';
import 'package:notes_app/auth/auth_repository.dart';
import 'package:notes_app/notes/notes_block.dart';
import 'package:notes_app/notes/notes_repository.dart';
import 'package:notes_app/screens/login_screen.dart';
import 'package:notes_app/screens/notes_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();
  final NotesRepository notesRepository = NotesRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider<NotesBloc>(
          create: (_) => NotesBloc(notesRepository: notesRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Notes App',
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return const NotesListScreen();
            } else if (state is Unauthenticated || state is AuthInitial) {
              return LoginScreen();
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
