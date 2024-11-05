import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/View/screens/constants/app_strings.dart';
import 'package:notes_app/View/screens/constants/colors.dart';
import 'package:notes_app/View/screens/constants/styles.dart';
import 'package:notes_app/View/widgets/responsive_layouts.dart';
import 'package:notes_app/bloc/notes_bloc/notes_bloc.dart';
import 'package:notes_app/View/screens/notes/add_edit_note_sceen.dart';
import '../../../data/models/note_model.dart';
import '../../../bloc/notes_bloc/notes_event.dart';
import 'package:intl/intl.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({Key? key, required this.note}) : super(key: key);

  void _deleteNote(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.deleteNote),
          content: const Text(AppStrings.deleteNoteConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                context.read<NotesBloc>().add(DeleteNote(noteId: note.id));
                Navigator.of(context)
                  ..pop()
                  ..pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note deleted')),
                );
              },
              child: const Text(AppStrings.delete),
            ),
          ],
        );
      },
    );
  }

  void _editNote(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditNoteScreen(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, MMMM d, y • h:mm a').format(note.timestamp);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: AppStyles.appBarIconTheme,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editNote(context),
            tooltip: AppStrings.editNoteTooltip,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteNote(context),
            tooltip: AppStrings.deleteNoteTooltip,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppStyles.backgroundGradient,
            ),
          ),
          // Note content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ResponsiveLayout(
                mobileLayout: _buildNoteContent(context, formattedDate),
                tabletLayout: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: _buildNoteContent(context, formattedDate),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteContent(BuildContext context, String formattedDate) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: AppStyles.cardBorderRadius,
      ),
      child: Padding(
        padding: AppStyles.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Note Title
            Text(
              note.title,
              style: AppStyles.noteTitleTextStyle,
            ),
            const SizedBox(height: 16.0),
            // Timestamp
            Row(
              children: [
                const Icon(Icons.access_time, size: 20, color: AppColors.grey),
                const SizedBox(width: 8.0),
                Text(
                  formattedDate,
                  style: AppStyles.timestampTextStyle,
                ),
              ],
            ),
            const Divider(height: 32.0),
            // Note Body
            Text(
              note.body,
              style: AppStyles.noteBodyTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
