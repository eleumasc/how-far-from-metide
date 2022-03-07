import 'package:dartz/dartz.dart';
import 'package:how_far_from_metide/domain/country.dart';
import 'package:how_far_from_metide/domain/failures.dart';

abstract class CountryRepository {
  Future<Either<Failure, List<Country>>> getAll();
}
