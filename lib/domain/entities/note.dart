import 'package:equatable/equatable.dart';

/// A class that represents a note, typically associated to a [[Country]].
class Note extends Equatable {
  final String text;

  /// [[Note]] constructor.
  const Note(this.text);

  @override
  List<Object?> get props => [text];
}
