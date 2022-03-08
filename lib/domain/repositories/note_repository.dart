import 'package:dartz/dartz.dart';
import 'package:how_far_from_metide/core/errors/failures.dart';
import 'package:how_far_from_metide/domain/entities/country.dart';
import 'package:how_far_from_metide/domain/entities/note.dart';

/// The contract for a [[Note]] repository.
abstract class NoteRepository {
  /// It returns a [[Future]] for either the [[Note]] object, if exists,
  /// associated to a given [[Country]], or a [[Failure]] in case of error.
  Future<Either<Failure, Note>> getByCountry(Country country);

  /// It associates a [[Note]] to a given [[Country]]; it returns a [[Future]]
  /// for either nothing if the operation succeeds, or a [[Failure]] in case of
  /// error.
  Future<Either<Failure, void>> putByCountry(Country country, Note note);
}
