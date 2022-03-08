import 'package:get_it/get_it.dart';
import 'package:how_far_from_metide/core/network/network_info.dart';
import 'package:how_far_from_metide/data/datasources/local_country_data_source.dart';
import 'package:how_far_from_metide/data/datasources/local_note_data_source.dart';
import 'package:how_far_from_metide/data/datasources/remote_country_data_source.dart';
import 'package:how_far_from_metide/data/repositories/country_repository_impl.dart';
import 'package:how_far_from_metide/data/repositories/note_repository_impl.dart';
import 'package:how_far_from_metide/domain/usecases/get_all_countries.dart';
import 'package:how_far_from_metide/domain/usecases/get_note_by_country.dart';
import 'package:how_far_from_metide/domain/usecases/put_note_by_country.dart';
import 'package:how_far_from_metide/presentation/bloc/detail_bloc.dart';
import 'package:how_far_from_metide/presentation/bloc/home_bloc.dart';
import 'package:how_far_from_metide/config.dart' as config;
import 'package:how_far_from_metide/domain/repositories/country_repository.dart';
import 'package:how_far_from_metide/domain/repositories/note_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:shared_preferences/shared_preferences.dart';

GetIt sl = GetIt.I;

/// It initializes the service locator.
Future<void> init() async {
  sl.registerLazySingleton<http.Client>(() =>
      http_auth.BasicAuthClient(config.remoteUsername, config.remotePassword));
  sl.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());

  sl.registerLazySingleton<RemoteCountryDataSource>(
      () => RemoteCountryDataSourceImpl(sl<http.Client>()));
  sl.registerLazySingleton<LocalCountryDataSource>(
      () => LocalCountryDataSourceImpl(sl<SharedPreferences>()));
  sl.registerLazySingleton<LocalNoteDataSource>(
      () => LocalNoteDataSourceImpl(sl<SharedPreferences>()));

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  sl.registerLazySingleton<CountryRepository>(() => CountryRepositoryImpl(
      sl<LocalCountryDataSource>(),
      sl<RemoteCountryDataSource>(),
      sl<NetworkInfo>()));
  sl.registerLazySingleton<NoteRepository>(
      () => NoteRepositoryImpl(sl<LocalNoteDataSource>()));

  sl.registerLazySingleton<GetAllCountries>(
      () => GetAllCountriesImpl(sl<CountryRepository>()));
  sl.registerLazySingleton<GetNoteByCountry>(
      () => GetNoteByCountryImpl(sl<NoteRepository>()));
  sl.registerLazySingleton<PutNoteByCountry>(
      () => PutNoteByCountryImpl(sl<NoteRepository>()));

  sl.registerFactory<HomeBloc>(() => HomeBloc(sl<GetAllCountries>()));
  sl.registerFactory<DetailBloc>(
      () => DetailBloc(sl<GetNoteByCountry>(), sl<PutNoteByCountry>()));
}
