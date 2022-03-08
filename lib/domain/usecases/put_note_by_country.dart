import 'package:dartz/dartz.dart';
import 'package:how_far_from_metide/core/errors/failures.dart';
import 'package:how_far_from_metide/domain/entities/country.dart';
import 'package:how_far_from_metide/domain/entities/note.dart';
import 'package:how_far_from_metide/domain/repositories/note_repository.dart';

/// Use case which puts the note associated to a country.
abstract class PutNoteByCountry {
  Future<Either<Failure, void>> call(Country country, Note note);
}

/// Default implementation of [[PutNoteByCountry]].
class PutNoteByCountryImpl extends PutNoteByCountry {
  final NoteRepository noteRepository;

  PutNoteByCountryImpl(this.noteRepository);

  @override
  Future<Either<Failure, void>> call(Country country, Note note) async {
    return await noteRepository.putByCountry(country, note);
  }
}
