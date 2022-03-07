import 'package:dartz/dartz.dart';
import 'package:how_far_from_metide/domain/country.dart';
import 'package:how_far_from_metide/domain/failures.dart';
import 'package:how_far_from_metide/domain/note.dart';

abstract class NoteRepository {
  Future<Either<Failure, Note>> getByCountry(Country country);

  Future<Either<Failure, void>> putByCountry(Country country, Note note);
}
