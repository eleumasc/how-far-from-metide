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

abstract class RemoteCountryDataSource {
  Future<List<Country>> fetchAll();
}

class RemoteCountryDataSourceImpl implements RemoteCountryDataSource {
  RemoteCountryDataSourceImpl(this.client);

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

const cachedCountries = "COUNTRIES";

abstract class LocalCountryDataSource {
  Future<List<Country>> readAll();

  Future<void> writeAll(List<Country> countries);
}

class LocalCountryDataSourceImpl implements LocalCountryDataSource {
  LocalCountryDataSourceImpl(this.sharedPreferences);

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

class CountryRepositoryImpl extends CountryRepository {
  CountryRepositoryImpl(
      this.localDataSource, this.remoteDataSource, this.networkInfo);

  final LocalCountryDataSource localDataSource;
  final RemoteCountryDataSource remoteDataSource;
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
