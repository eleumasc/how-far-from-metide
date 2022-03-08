import 'package:dartz/dartz.dart';
import 'package:how_far_from_metide/core/errors/failures.dart';
import 'package:how_far_from_metide/core/util/country_comparators.dart';
import 'package:how_far_from_metide/domain/entities/country.dart';
import 'package:how_far_from_metide/domain/repositories/country_repository.dart';

/// Use case which gets all the countries.
abstract class GetAllCountries {
  Future<Either<Failure, List<Country>>> call();
}

/// Default implementation of [[GetAllCountries]].
class GetAllCountriesImpl extends GetAllCountries {
  final CountryRepository countryRepository;

  GetAllCountriesImpl(this.countryRepository);

  @override
  Future<Either<Failure, List<Country>>> call() async {
    var failureOrCountries = await countryRepository.getAll();
    return failureOrCountries.fold(
      (failure) => Left(failure),
      (countries) {
        countries.sort(byDistance);
        return Right(countries);
      },
    );
  }
}
