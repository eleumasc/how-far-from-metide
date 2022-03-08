import 'dart:convert';

import 'package:how_far_from_metide/data/models/country_model.dart';
import 'package:how_far_from_metide/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The key that identifies the list of all the [[CountryModel]]s in the
/// local cache.
const cachedCountries = "COUNTRIES";

/// A contract for a local data source of [[CountryModel]]s.
abstract class LocalCountryDataSource {
  /// It returns a [[Future]] for the list of all the [[CountryModel]]s
  /// which are available in the local data source.
  /// It throws [[CacheException]] if a cache-related error occurs.
  Future<List<CountryModel>> readAll();

  /// It stores the list of all the [[CountryModel]]s into the local
  /// data source.
  /// It throws [[CacheException]] if a cache-related error occurs.
  Future<void> writeAll(List<CountryModel> countryModels);
}

/// The default implementation of [[LocalCountryDataSource]].
/// It uses [[SharedPreferences]] to retrieve and store [[CountryModel]]s in
/// the local cache.
class LocalCountryDataSourceImpl implements LocalCountryDataSource {
  /// [[LocalCountryDataSourceImpl]] constructor.
  LocalCountryDataSourceImpl(this.sharedPreferences);

  /// The instance of [[SharedPreferences]].
  final SharedPreferences sharedPreferences;

  @override
  Future<List<CountryModel>> readAll() async {
    String? json = sharedPreferences.getString(cachedCountries);
    if (json != null) {
      List<dynamic> data = jsonDecode(json);
      List<CountryModel> result = data
          .map((countryData) => CountryModel.fromJson(countryData))
          .toList();
      return result;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> writeAll(List<CountryModel> countryModels) async {
    String json =
        jsonEncode(countryModels.map((country) => country.toJson()).toList());
    await sharedPreferences.setString(cachedCountries, json);
  }
}
