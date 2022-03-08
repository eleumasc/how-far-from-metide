import 'package:dartz/dartz.dart';
import 'package:how_far_from_metide/domain/country.dart';
import 'package:how_far_from_metide/domain/exceptions.dart';
import 'package:how_far_from_metide/domain/failures.dart';
import 'package:how_far_from_metide/domain/note.dart';
import 'package:how_far_from_metide/domain/note_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The key prefix that identifies a [[Note]] associated to a [[Country]] in the
/// local cache.
const cachedNotePrefix = "NOTE_";

/// A contract for a local data source of [[Note]] objects.
abstract class LocalNoteDataSource {
  /// It returns a [[Future]] for the [[Note]] associated to a given [[Country]]
  /// in the local data source.
  /// It throws [[CacheException]] if a cache-related error occurs, including if
  /// the searched [[Note]] does not exist.
  Future<Note> readByCountry(Country country);

  /// It stores the [[Note]] associated to a given [[Country]] into the
  /// local data source.
  /// It throws [[CacheException]] if a cache-related error occurs.
  Future<void> writeByCountry(Country country, Note note);
}

/// The default implementation of [[LocalNoteDataSource]].
/// It uses [[SharedPreferences]] to retrieve and store [[Note]] objects in
/// the local cache.
class LocalNoteDataSourceImpl implements LocalNoteDataSource {
  /// [[LocalNoteDataSourceImpl]] constructor.
  LocalNoteDataSourceImpl(this.sharedPreferences);

  /// The instance of [[SharedPreferences]].
  final SharedPreferences sharedPreferences;

  @override
  Future<Note> readByCountry(Country country) async {
    String? text = sharedPreferences.getString(_getCacheId(country));
    if (text != null) {
      return Note(text);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> writeByCountry(Country country, Note note) async {
    await sharedPreferences.setString(_getCacheId(country), note.text);
  }

  /// It returns the actual key that identifies the [[Note]] of a given
  /// [[Country]] in the local cache.
  /// It throws [[CacheException]] if the given country has no id attribute.
  String _getCacheId(Country country) {
    if (country.id != null) {
      return cachedNotePrefix + country.id.toString();
    } else {
      throw CacheException();
    }
  }
}

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
      return Right(await localDataSource.writeByCountry(country, note));
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
