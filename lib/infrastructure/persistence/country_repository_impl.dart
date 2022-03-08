import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:how_far_from_metide/domain/country.dart';
import 'package:how_far_from_metide/domain/country_repository.dart';
import 'package:how_far_from_metide/domain/exceptions.dart';
import 'package:how_far_from_metide/domain/failures.dart';
import 'package:how_far_from_metide/infrastructure/network/network_info.dart';
import 'package:how_far_from_metide/config.dart' as config;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A contract for a remote data source of [[Country]] objects.
abstract class RemoteCountryDataSource {
  /// It returns a [[Future]] for the list of all the [[Country]] objects
  /// which are available in the remote data source.
  /// It throws [[ServerException]] if an server-related error occurs.
  Future<List<Country>> fetchAll();
}

/// The default implementation of [[RemoteCountryDataSource]].
/// It uses an HTTP client to fetch [[Country]] objects from the remote API.
class RemoteCountryDataSourceImpl implements RemoteCountryDataSource {
  /// [[RemoteCountryDataSourceImpl]] constructor.
  RemoteCountryDataSourceImpl(this.client);

  /// The instance of an HTTP client.
  final http.Client client;

  @override
  Future<List<Country>> fetchAll() async {
    try {
      http.Response response = await client.get(Uri.parse(config.remoteUrl));
      String json = response.body;
      List<dynamic> data = jsonDecode(json);
      List<Country> result =
          data.map((countryData) => Country.fromJson(countryData)).toList();
      return result;
    } catch (_) {
      throw ServerException();
    }
  }
}

/// The key that identifies the list of all the [[Country]] objects in the
/// local cache.
const cachedCountries = "COUNTRIES";

/// A contract for a local data source of [[Country]] objects.
abstract class LocalCountryDataSource {
  /// It returns a [[Future]] for the list of all the [[Country]] objects
  /// which are available in the local data source.
  /// It throws [[CacheException]] if a cache-related error occurs.
  Future<List<Country>> readAll();

  /// It stores the list of all the [[Country]] objects into the local
  /// data source.
  /// It throws [[CacheException]] if a cache-related error occurs.
  Future<void> writeAll(List<Country> countries);
}

/// The default implementation of [[LocalCountryDataSource]].
/// It uses [[SharedPreferences]] to retrieve and store [[Country]] objects in
/// the local cache.
class LocalCountryDataSourceImpl implements LocalCountryDataSource {
  /// [[LocalCountryDataSourceImpl]] constructor.
  LocalCountryDataSourceImpl(this.sharedPreferences);

  /// The instance of [[SharedPreferences]].
  final SharedPreferences sharedPreferences;

  @override
  Future<List<Country>> readAll() async {
    String? json = sharedPreferences.getString(cachedCountries);
    if (json != null) {
      List<dynamic> data = jsonDecode(json);
      List<Country> result =
          data.map((countryData) => Country.fromJson(countryData)).toList();
      return result;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> writeAll(List<Country> countries) async {
    String json =
        jsonEncode(countries.map((country) => country.toJson()).toList());
    await sharedPreferences.setString(cachedCountries, json);
  }
}

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
        List<Country> data = await remoteDataSource.fetchAll();
        localDataSource.writeAll(data);
        return Right(data);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        List<Country> data = await localDataSource.readAll();
        return Right(data);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
