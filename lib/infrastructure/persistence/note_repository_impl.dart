import 'package:dartz/dartz.dart';
import 'package:how_far_from_metide/domain/country.dart';
import 'package:how_far_from_metide/domain/exceptions.dart';
import 'package:how_far_from_metide/domain/failures.dart';
import 'package:how_far_from_metide/domain/note.dart';
import 'package:how_far_from_metide/domain/note_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const cachedNotePrefix = "NOTE_";

abstract class LocalNoteDataSource {
  Future<Note> readByCountry(Country country);

  Future<void> writeByCountry(Country country, Note note);
}

class LocalNoteDataSourceImpl implements LocalNoteDataSource {
  LocalNoteDataSourceImpl(this.sharedPreferences);

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

  String _getCacheId(Country country) {
    if (country.id != null) {
      return cachedNotePrefix + country.id.toString();
    } else {
      throw CacheException();
    }
  }
}

class NoteRepositoryImpl extends NoteRepository {
  NoteRepositoryImpl(this.localDataSource);

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
