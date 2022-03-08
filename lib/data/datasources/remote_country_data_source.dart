import 'dart:convert';

import 'package:how_far_from_metide/config.dart' as config;
import 'package:how_far_from_metide/data/models/country_model.dart';
import 'package:how_far_from_metide/core/errors/exceptions.dart';
import 'package:http/http.dart' as http;

/// A contract for a remote data source of [[CountryModel]]s.
abstract class RemoteCountryDataSource {
  /// It returns a [[Future]] for the list of all the [[CountryModel]]s
  /// which are available in the remote data source.
  /// It throws [[ServerException]] if an server-related error occurs.
  Future<List<CountryModel>> fetchAll();
}

/// The default implementation of [[RemoteCountryDataSource]].
/// It uses an HTTP client to fetch [[CountryModel]]s from the remote API.
class RemoteCountryDataSourceImpl implements RemoteCountryDataSource {
  /// [[RemoteCountryDataSourceImpl]] constructor.
  RemoteCountryDataSourceImpl(this.client);

  /// The instance of an HTTP client.
  final http.Client client;

  @override
  Future<List<CountryModel>> fetchAll() async {
    try {
      http.Response response = await client.get(Uri.parse(config.remoteUrl));
      String json = response.body;
      List<dynamic> data = jsonDecode(json);
      List<CountryModel> result = data
          .map((countryData) => CountryModel.fromJson(countryData))
          .toList();
      return result;
    } catch (_) {
      throw ServerException();
    }
  }
}
