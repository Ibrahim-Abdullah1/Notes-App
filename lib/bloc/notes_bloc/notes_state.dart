import '../../data/models/note_model.dart';

abstract class NotesState {}

class NotesInitial extends NotesState {
}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<Note> allNotes;
  final List<Note> filteredNotes;
  final String searchQuery;
  NotesLoaded({
    required this.allNotes,
    required this.filteredNotes,
    required this.searchQuery,
  });
}

class NotesError extends NotesState {
  final String message;
  NotesError({required this.message});
}
