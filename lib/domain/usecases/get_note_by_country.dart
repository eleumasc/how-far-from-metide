import 'package:dartz/dartz.dart';
import 'package:how_far_from_metide/core/errors/failures.dart';
import 'package:how_far_from_metide/domain/entities/country.dart';
import 'package:how_far_from_metide/domain/entities/note.dart';
import 'package:how_far_from_metide/domain/repositories/note_repository.dart';

/// Use case which gets the note associated to a country.
abstract class GetNoteByCountry {
  Future<Either<Failure, Note>> call(Country country);
}

/// Default implementation of [[GetNoteByCountry]].
class GetNoteByCountryImpl extends GetNoteByCountry {
  final NoteRepository noteRepository;

  GetNoteByCountryImpl(this.noteRepository);

  @override
  Future<Either<Failure, Note>> call(Country country) async {
    return await noteRepository.getByCountry(country);
  }
}
