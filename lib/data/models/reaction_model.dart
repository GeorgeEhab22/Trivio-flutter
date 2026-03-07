import 'package:auth/core/json_parser.dart';
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
    final dynamic userRaw = json['userId'] ?? json['user'] ?? json['author'];
    final bool isUserPopulated = userRaw is Map<String, dynamic>;

    return ReactionModel(
      id: JsonParser.parseId(json['_id'] ?? json['id']) ?? '',
      userId: JsonParser.parseId(userRaw) ?? '',
      postId: JsonParser.parseId(json['modelId'] ?? json['postId']) ?? '',
      type: JsonParser.parseReactionType(json['reaction'] ?? json['type']),
      username: isUserPopulated 
          ? JsonParser.parseString(userRaw['username']) 
          : JsonParser.parseString(json['username']),
      profilePicture: isUserPopulated 
          ? JsonParser.parseString(userRaw['profilePicture'] ?? userRaw['profileImage']) 
          : JsonParser.parseString(json['profilePicture']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'postId': postId,
      'reaction': type.name, 
      'username': username,
      'profilePicture': profilePicture,
    };
  }

  Reaction toEntity() => Reaction(
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
}