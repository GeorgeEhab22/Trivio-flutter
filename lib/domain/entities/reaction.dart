import 'package:equatable/equatable.dart';

class Reaction extends Equatable {
  final String id;
  final String userId;
  final String postId;
  final String type; 

  const Reaction({
    required this.id,
    required this.userId,
    required this.postId,
    required this.type,
  });

  @override
  List<Object?> get props => [userId, postId, type];
}
