import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/notes/notes_block.dart';
import 'package:notes_app/screens/add_edit_note_sceen.dart';
import '../models/note_model.dart';
import '../notes/notes_event.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  NoteDetailScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    void _deleteNote() {
      context.read<NotesBloc>().add(DeleteNote(noteId: note.id));
      Navigator.pop(context);
    }

    void _editNote() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddEditNoteScreen(note: note),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: _editNote),
          IconButton(icon: Icon(Icons.delete), onPressed: _deleteNote),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(note.body),
      ),
    );
  }
}
