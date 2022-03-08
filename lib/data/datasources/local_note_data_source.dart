import 'package:how_far_from_metide/data/models/note_model.dart';
import 'package:how_far_from_metide/domain/entities/country.dart';
import 'package:how_far_from_metide/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The key prefix that identifies a [[NoteModel]] associated to a [[Country]]
/// in the local cache.
const cachedNotePrefix = "NOTE_";

/// A contract for a local data source of [[NoteModel]]s.
abstract class LocalNoteDataSource {
  /// It returns a [[Future]] for the [[NoteModel]] associated to a given
  /// [[Country]] in the local data source.
  /// It throws [[CacheException]] if a cache-related error occurs, including if
  /// the searched [[NoteModel]] does not exist.
  Future<NoteModel> readByCountry(Country country);

  /// It stores the [[NoteModel]] associated to a given [[Country]] into the
  /// local data source.
  /// It throws [[CacheException]] if a cache-related error occurs.
  Future<void> writeByCountry(Country country, NoteModel noteModel);
}

/// The default implementation of [[LocalNoteDataSource]].
/// It uses [[SharedPreferences]] to retrieve and store [[NoteModel]]s in
/// the local cache.
class LocalNoteDataSourceImpl implements LocalNoteDataSource {
  /// [[LocalNoteDataSourceImpl]] constructor.
  LocalNoteDataSourceImpl(this.sharedPreferences);

  /// The instance of [[SharedPreferences]].
  final SharedPreferences sharedPreferences;

  @override
  Future<NoteModel> readByCountry(Country country) async {
    String? text = sharedPreferences.getString(_getCacheId(country));
    if (text != null) {
      return NoteModel(text);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> writeByCountry(Country country, NoteModel noteModel) async {
    await sharedPreferences.setString(_getCacheId(country), noteModel.text);
  }

  /// It returns the actual key that identifies the [[NoteModel]] of a given
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
