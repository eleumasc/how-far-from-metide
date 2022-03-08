import 'package:how_far_from_metide/domain/entities/note.dart';

/// A [[Note]] model.
class NoteModel extends Note {
  /// [[NoteModel]] constructor.
  const NoteModel(text) : super(text);

  @override
  List<Object?> get props => [text];

  factory NoteModel.fromNote(Note note) {
    return NoteModel(note.text);
  }

  /// It constructs a new [[NoteModel]] from a JSON object.
  factory NoteModel.fromJson(Map<String, dynamic> data) {
    return NoteModel(data["text"]);
  }

  /// It return a JSON object representing this [[NoteModel]].
  Map<String, dynamic> toJson() {
    return {
      "text": text,
    };
  }
}
