import 'package:equatable/equatable.dart';

/// A class for a generic, functional failure.
abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

/// A [[Failure]] related to some interaction with the server (see also [[ServerException]]).
class ServerFailure extends Failure {}

/// A [[Failure]] related to some interaction with the local cache (see also [[CacheException]]).
class CacheFailure extends Failure {}
