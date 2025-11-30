import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/reaction_type.dart';

class ReactionModel extends Reaction {
  const ReactionModel({
    required super.id,
    required super.userId,
    required super.postId,
    required super.type,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      postId: json['postId'] ?? '',
      type: _mapStringToReactionType(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'userId': userId, 'postId': postId, 'type': type.name};
  }

  Reaction toEntity() =>
      Reaction(id: id, userId: userId, postId: postId, type: type);

  factory ReactionModel.fromEntity(Reaction reaction) {
    return ReactionModel(
      id: reaction.id,
      userId: reaction.userId,
      postId: reaction.postId,
      type: reaction.type,
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
