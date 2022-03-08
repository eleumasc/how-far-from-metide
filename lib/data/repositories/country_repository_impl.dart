import 'package:dartz/dartz.dart';
import 'package:how_far_from_metide/core/errors/failures.dart';
import 'package:how_far_from_metide/data/datasources/local_country_data_source.dart';
import 'package:how_far_from_metide/data/datasources/remote_country_data_source.dart';
import 'package:how_far_from_metide/data/models/country_model.dart';
import 'package:how_far_from_metide/domain/entities/country.dart';
import 'package:how_far_from_metide/domain/repositories/country_repository.dart';
import 'package:how_far_from_metide/core/errors/exceptions.dart';
import 'package:how_far_from_metide/core/network/network_info.dart';

/// The default implementation of [[CountryRepository]].
/// It uses a [[RemoteCountryDataSource]] and a [[LocalCountryDataSource]],
/// whose usage depends on the Internet connection status provided by
/// [[NetworkInfo]].
/// In particular, if the device is online, then data is fetched from
/// [[RemoteCountryDataSource]] and stored into [[LocalCountryDataSource]];
/// otherwise, data is read from [[LocalCountryDataSource]], if available.
/// In case of error, it returns [[ServerFailure]] or [[CacheFailure]],
/// accordingly.
class CountryRepositoryImpl extends CountryRepository {
  /// [[CountryRepositoryImpl]] constructor.
  CountryRepositoryImpl(
      this.localDataSource, this.remoteDataSource, this.networkInfo);

  /// The instance of [[LocalCountryDataSource]].
  final LocalCountryDataSource localDataSource;

  /// The instance of [[RemoteCountryDataSource]].
  final RemoteCountryDataSource remoteDataSource;

  /// The instance of [[NetworkInfo]].
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<Country>>> getAll() async {
    if (await networkInfo.isConnected) {
      try {
        List<CountryModel> countryModels = await remoteDataSource.fetchAll();
        localDataSource.writeAll(countryModels);
        return Right(countryModels);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        List<Country> countryModels = await localDataSource.readAll();
        return Right(countryModels);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
