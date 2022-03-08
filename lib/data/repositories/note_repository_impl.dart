import 'package:dartz/dartz.dart';
import 'package:how_far_from_metide/core/errors/failures.dart';
import 'package:how_far_from_metide/data/datasources/local_note_data_source.dart';
import 'package:how_far_from_metide/data/models/note_model.dart';
import 'package:how_far_from_metide/domain/entities/country.dart';
import 'package:how_far_from_metide/core/errors/exceptions.dart';
import 'package:how_far_from_metide/domain/entities/note.dart';
import 'package:how_far_from_metide/domain/repositories/note_repository.dart';

/// The default implementation of [[NoteRepository]].
/// Data is read from and written to [[LocalNoteDataSource]].
/// In case of error, it returns [[CacheFailure]].
class NoteRepositoryImpl extends NoteRepository {
  /// [[NoteRepositoryImpl]] constructor.
  NoteRepositoryImpl(this.localDataSource);

  /// The instance of [[LocalNoteDataSource]].
  final LocalNoteDataSource localDataSource;

  @override
  Future<Either<Failure, Note>> getByCountry(Country country) async {
    try {
      return Right(await localDataSource.readByCountry(country));
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> putByCountry(Country country, Note note) async {
    try {
      return Right(await localDataSource.writeByCountry(
          country, NoteModel.fromNote(note)));
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
