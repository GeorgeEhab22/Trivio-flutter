import 'package:equatable/equatable.dart';

// will be used to store edit history of comment
class CommentRevision extends Equatable {
  final String text;
  final DateTime editTime;

  const CommentRevision({
    required this.text,
    required this.editTime,
  });

  @override
  List<Object?> get props => [text, editTime];
}