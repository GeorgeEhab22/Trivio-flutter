import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/reaction_type.dart';

class ReactionModel extends Reaction {
  const ReactionModel({
    required super.id,
    required super.userId,
    required super.postId,
    required super.type,
    super.username,
    super.profilePicture,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    String parseIdSafely(dynamic value) {
      if (value == null) return '';
      if (value is Map<String, dynamic>) {
        final nested = value['_id'] ?? value['id'] ?? '';
        return nested.toString();
      }
      return value.toString();
    }

    final rawUser = json['userId'] ?? json['user'] ?? json['author'];
    final userMap = rawUser is Map<String, dynamic> ? rawUser : null;

    return ReactionModel(
      id: parseIdSafely(json['_id'] ?? json['id']),
      userId: parseIdSafely(rawUser),
      postId: parseIdSafely(
        json['postId'] ?? json['modelId'],
      ),
      type: _mapStringToReactionType(
        json['type'] ?? json['reaction'],
      ),
      username: userMap?['username']?.toString(),
      profilePicture: userMap?['profilePicture']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'postId': postId,
      'type': type.name,
      'username': username,
      'profilePicture': profilePicture,
    };
  }

  Reaction toEntity() =>
      Reaction(
        id: id,
        userId: userId,
        postId: postId,
        type: type,
        username: username,
        profilePicture: profilePicture,
      );

  factory ReactionModel.fromEntity(Reaction reaction) {
    return ReactionModel(
      id: reaction.id,
      userId: reaction.userId,
      postId: reaction.postId,
      type: reaction.type,
      username: reaction.username,
      profilePicture: reaction.profilePicture,
    );
  }

  factory ReactionModel.empty() {
    return const ReactionModel(
      id: '',
      userId: '',
      postId: '',
      type: ReactionType.none,
    );
  }

  static ReactionType _mapStringToReactionType(String? typeStr) {
    if (typeStr == null) return ReactionType.none;

    try {
      return ReactionType.values.firstWhere((e) => e.name == typeStr);
    } catch (e) {
      return ReactionType.none;
    }
  }
}
