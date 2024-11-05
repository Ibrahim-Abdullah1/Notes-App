import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/View/screens/constants/app_strings.dart';
import 'package:notes_app/View/widgets/notes_card.dart';
import 'package:notes_app/View/widgets/responsive_layouts.dart';
import 'package:notes_app/bloc/auth_bloc/auth_event.dart';
import 'package:notes_app/bloc/notes_bloc/notes_bloc.dart';
import 'package:notes_app/View/screens/notes/add_edit_note_sceen.dart';
import 'package:notes_app/data/models/note_model.dart';
import '../../../bloc/notes_bloc/notes_event.dart';
import '../../../bloc/notes_bloc/notes_state.dart';
import '../../../bloc/auth_bloc/auth_bloc.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({Key? key}) : super(key: key);

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(LoadNotes());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context
        .read<NotesBloc>()
        .add(UpdateSearchQuery(query: _searchController.text));
  }

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(SignOutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.yourNotes),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: AppStrings.logoutTooltip,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SearchBar(controller: _searchController),
          ),
        ),
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotesLoaded) {
            final notes = state.filteredNotes;
            if (notes.isEmpty) {
              return const Center(child: Text(AppStrings.noNotesFound));
            }
            return ResponsiveLayout(
              mobileLayout: _buildNotesList(notes),
              tabletLayout: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: _buildNotesList(notes),
                ),
              ),
            );
          } else if (state is NotesError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditNoteScreen()),
          );
        },
        tooltip: AppStrings.addNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotesList(List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          onDelete: () {
            context.read<NotesBloc>().add(DeleteNote(noteId: note.id));
          },
        );
      },
    );
  }
}
