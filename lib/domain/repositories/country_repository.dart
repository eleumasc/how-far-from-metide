import 'package:dartz/dartz.dart';
import 'package:how_far_from_metide/core/errors/failures.dart';
import 'package:how_far_from_metide/domain/entities/country.dart';

/// The contract for a [[Country]] repository.
abstract class CountryRepository {
  /// It returns a [[Future]] for either the list of all the [[Country]] objects
  /// in the repository, or a [[Failure]] in case of error.
  Future<Either<Failure, List<Country>>> getAll();
}
