import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_far_from_metide/domain/country.dart';
import 'package:how_far_from_metide/domain/note.dart';
import 'package:how_far_from_metide/domain/note_repository.dart';

abstract class DetailEvent extends Equatable {
  final Country country;

  const DetailEvent(this.country);

  @override
  List<Object?> get props => [];
}

class DetailNoteLoaded extends DetailEvent {
  const DetailNoteLoaded(Country country) : super(country);
}

class DetailNoteChanged extends DetailEvent {
  const DetailNoteChanged(Country country) : super(country);
}

class DetailNoteSaved extends DetailEvent {
  const DetailNoteSaved(Country country, this.noteText) : super(country);

  final String noteText;

  @override
  List<Object?> get props => [noteText];
}

abstract class DetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetailInitialState extends DetailState {}

class DetailSetupState extends DetailState {
  DetailSetupState(this.initialNoteText);

  final String initialNoteText;

  @override
  List<Object?> get props => [initialNoteText];
}

class DetailReadyState extends DetailState {
  DetailReadyState(this.dirty);

  final bool dirty;

  @override
  List<Object?> get props => [dirty];
}

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final NoteRepository noteRepository;

  DetailBloc(this.noteRepository) : super(DetailInitialState()) {
    on<DetailNoteLoaded>(
      (event, emit) async {
        var eitherFailureOrNote =
            await noteRepository.getByCountry(event.country);
        eitherFailureOrNote.fold(
          (_) {},
          (note) {
            emit(DetailSetupState(note.text));
            emit(DetailReadyState(false));
          },
        );
      },
    );

    on<DetailNoteChanged>(
      (event, emit) {
        emit(DetailReadyState(true));
      },
    );

    on<DetailNoteSaved>(
      (event, emit) async {
        await noteRepository.putByCountry(event.country, Note(event.noteText));
        emit(DetailReadyState(false));
      },
    );
  }
}
