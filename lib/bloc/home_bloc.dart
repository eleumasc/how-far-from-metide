import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_far_from_metide/domain/country.dart';
import 'package:how_far_from_metide/domain/country_repository.dart';
import 'package:how_far_from_metide/domain/country_comparators.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeCountriesFetched extends HomeEvent {}

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeReadyState extends HomeState {
  final List<Country> countries;

  HomeReadyState(this.countries);

  @override
  List<Object> get props => [countries];
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CountryRepository countryRepository;

  HomeBloc(this.countryRepository) : super(HomeInitialState()) {
    on<HomeCountriesFetched>((event, emit) async {
      var eitherFailureOrCountries = await countryRepository.getAll();
      eitherFailureOrCountries.fold((_) {}, (countries) {
        countries.sort(byDistance);
        emit(HomeReadyState(countries));
      });
    });
  }
}
