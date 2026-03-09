import 'package:auth/domain/entities/reaction_type.dart';
import 'package:equatable/equatable.dart';

class Reaction extends Equatable {
  final String id;
  final String userId;
  final String postId;
  final ReactionType type;
  final String? username;
  final String? profilePicture;

  const Reaction({
    required this.id,
    required this.userId,
    required this.postId,
    required this.type,
    this.username,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    postId,
    type,
    username,
    profilePicture,
  ];
}
