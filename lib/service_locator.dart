import 'package:get_it/get_it.dart';
import 'package:how_far_from_metide/bloc/detail_bloc.dart';
import 'package:how_far_from_metide/bloc/home_bloc.dart';
import 'package:how_far_from_metide/config.dart' as config;
import 'package:how_far_from_metide/domain/country_repository.dart';
import 'package:how_far_from_metide/domain/note_repository.dart';
import 'package:how_far_from_metide/infrastructure/network/network_info.dart';
import 'package:how_far_from_metide/infrastructure/persistence/country_repository_impl.dart';
import 'package:how_far_from_metide/infrastructure/persistence/note_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:shared_preferences/shared_preferences.dart';

GetIt sl = GetIt.I;

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

  sl.registerFactory<HomeBloc>(() => HomeBloc(sl<CountryRepository>()));
  sl.registerFactory<DetailBloc>(() => DetailBloc(sl<NoteRepository>()));
}