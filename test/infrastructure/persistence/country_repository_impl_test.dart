import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:how_far_from_metide/domain/country.dart';
import 'package:how_far_from_metide/domain/exceptions.dart';
import 'package:how_far_from_metide/domain/failures.dart';
import 'package:how_far_from_metide/infrastructure/network/network_info.dart';
import 'package:how_far_from_metide/infrastructure/persistence/country_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/fixture_reader.dart';

class MockLocalCountryDataSource extends Mock
    implements LocalCountryDataSource {}

class MockRemoteCountryDataSource extends Mock
    implements RemoteCountryDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockLocalCountryDataSource mockLocalDataSource;
  late MockRemoteCountryDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  late CountryRepositoryImpl countryRepositoryImpl;

  setUp(() {
    mockLocalDataSource = MockLocalCountryDataSource();
    mockRemoteDataSource = MockRemoteCountryDataSource();
    mockNetworkInfo = MockNetworkInfo();
    countryRepositoryImpl = CountryRepositoryImpl(
        mockLocalDataSource, mockRemoteDataSource, mockNetworkInfo);
  });

  group("getAll", () {
    final String tJson = fixture("countries.json");
    final List<dynamic> tData = jsonDecode(tJson);
    final List<Country> tCountries =
        tData.map((tCountryData) => Country.fromJson(tCountryData)).toList();

    group("device is online", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        "should return remote data when the call to remote data source is successful",
        () async {
          // arrange
          when(() => mockRemoteDataSource.fetchAll())
              .thenAnswer((_) async => tCountries);
          when(() => mockLocalDataSource.writeAll(any()))
              .thenAnswer((_) async {});
          // act
          final result = await countryRepositoryImpl.getAll();
          // assert
          verify(() => mockRemoteDataSource.fetchAll()).called(1);
          expect(result, equals(Right(tCountries)));
        },
      );

      test(
        "should cache the data locally when the call to remote data source is successful",
        () async {
          // arrange
          when(() => mockRemoteDataSource.fetchAll())
              .thenAnswer((_) async => tCountries);
          when(() => mockLocalDataSource.writeAll(any()))
              .thenAnswer((_) async {});
          // act
          await countryRepositoryImpl.getAll();
          // assert
          verify(() => mockRemoteDataSource.fetchAll()).called(1);
          verify(() => mockLocalDataSource.writeAll(tCountries)).called(1);
        },
      );

      test(
        "should return server failure when the call to remote data source is unsuccessful",
        () async {
          // arrange
          when(() => mockRemoteDataSource.fetchAll())
              .thenThrow(ServerException());
          // act
          final result = await countryRepositoryImpl.getAll();
          // assert
          verify(() => mockRemoteDataSource.fetchAll()).called(1);
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group("device is offline", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        "should should return last locally cached data when the cached data is present",
        () async {
          // arrange
          when(() => mockLocalDataSource.readAll())
              .thenAnswer((_) async => tCountries);
          // act
          final result = await countryRepositoryImpl.getAll();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.readAll()).called(1);
          expect(result, equals(Right(tCountries)));
        },
      );

      test(
        "should return CacheFailure when there is no cached data present",
        () async {
          // arrange
          when(() => mockLocalDataSource.readAll()).thenThrow(CacheException());
          // act
          final result = await countryRepositoryImpl.getAll();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.readAll()).called(1);
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
