// presentation/widgets/note_card.dart
import 'package:flutter/material.dart';
import 'package:notes_app/View/screens/constants/app_strings.dart';
import 'package:notes_app/View/screens/constants/colors.dart';
import 'package:notes_app/View/screens/notes/add_edit_note_sceen.dart';
import 'package:notes_app/View/screens/notes/notes_detail_screen.dart';
import 'package:notes_app/data/models/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;

  const NoteCard({
    Key? key,
    required this.note,
    required this.onDelete,
  }) : super(key: key);

  void _editNote(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditNoteScreen(note: note),
      ),
    );
  }

  void _viewNoteDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteDetailScreen(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        color: AppColors.primaryColor,
        child: const Icon(
          Icons.delete,
          color: AppColors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        final bool? res = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(AppStrings.deleteNote),
              content: const Text(AppStrings.deleteNoteConfirmation),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(AppStrings.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(AppStrings.delete),
                ),
              ],
            );
          },
        );
        return res ?? false;
      },
      onDismissed: (direction) {
        onDelete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.noteDeleted)),
        );
      },
      child: GestureDetector(
        onTap: () => _viewNoteDetail(context),
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  note.body.length > 100
                      ? '${note.body.substring(0, 100)}...'
                      : note.body,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
