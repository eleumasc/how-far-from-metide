import 'package:equatable/equatable.dart';

/// A class that represents a note, typically associated to a [[Country]].
class Note extends Equatable {
  final String text;

  /// [[Note]] constructor.
  const Note(this.text);

  @override
  List<Object?> get props => [text];

  /// It constructs a new [[Note]] from a JSON object.
  factory Note.fromJson(Map<String, dynamic> data) {
    return Note(data["text"]);
  }

  /// It return a JSON object representing this [[Note]].
  Map<String, dynamic> toJson() {
    return {
      "text": text,
    };
  }
}
