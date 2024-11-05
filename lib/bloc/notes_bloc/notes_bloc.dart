import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/data/models/note_model.dart';
import '../../data/repository/notes_repository.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository notesRepository;
  List<Note> allNotes = [];
  String searchQuery = '';

  NotesBloc({required this.notesRepository}) : super(NotesInitial()) {
    on<LoadNotes>((event, emit) async {
      emit(NotesLoading());
      try {
        final notesStream = notesRepository.getNotes();
        await emit.forEach<List<Note>>(
          notesStream,
          onData: (notes) {
            allNotes = notes;
            final filteredNotes = _applySearch(notes, searchQuery);
            return NotesLoaded(
              allNotes: notes,
              filteredNotes: filteredNotes,
              searchQuery: searchQuery,
            );
          },
          onError: (e, _) => NotesError(message: e.toString()),
        );
      } catch (e) {
        emit(NotesError(message: e.toString()));
      }
    });

    on<UpdateSearchQuery>((event, emit) {
      searchQuery = event.query;
      final filteredNotes = _applySearch(allNotes, searchQuery);
      emit(NotesLoaded(
        allNotes: allNotes,
        filteredNotes: filteredNotes,
        searchQuery: searchQuery,
      ));
    });

    on<AddNote>((event, emit) async {
      await notesRepository.addNote(event.note);
    });

    on<UpdateNote>((event, emit) async {
      await notesRepository.updateNote(event.note);
    });

    on<DeleteNote>((event, emit) async {
      await notesRepository.deleteNote(event.noteId);
    });
  }

  List<Note> _applySearch(List<Note> notes, String query) {
    if (query.isEmpty) {
      return notes;
    } else {
      final queryLower = query.toLowerCase();
      return notes.where((note) {
        final titleLower = note.title.toLowerCase();
        final bodyLower = note.body.toLowerCase();
        return titleLower.contains(queryLower) || bodyLower.contains(queryLower);
      }).toList();
    }
  }
}
