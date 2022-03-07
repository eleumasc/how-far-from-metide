import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String text;

  const Note(this.text);

  @override
  List<Object?> get props => [text];

  factory Note.fromJson(Map<String, dynamic> data) {
    return Note(data["text"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "text": text,
    };
  }
}
