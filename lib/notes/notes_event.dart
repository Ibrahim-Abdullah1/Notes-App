import '../models/note_model.dart';

abstract class NotesEvent {}

class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final Note note;
  AddNote({required this.note});
}

class UpdateNote extends NotesEvent {
  final Note note;
  UpdateNote({required this.note});
}

class DeleteNote extends NotesEvent {
  final String noteId;
  DeleteNote({required this.noteId});
}

class ReorderNotes extends NotesEvent {
  final List<Note> notes;
  ReorderNotes({required this.notes});
}

class UpdateSearchQuery extends NotesEvent {
  final String query;
  UpdateSearchQuery({required this.query});
}

