import 'package:auth/constants/paths.dart';
import 'package:auth/domain/entities/reaction_type.dart';

extension ReactionTypeExtension on ReactionType {
  String get emojiPath {
    switch (this) {
      case ReactionType.like: return Paths.likeEmoji;
      case ReactionType.love: return Paths.loveEmoji;
      case ReactionType.haha: return Paths.hahaEmoji;
      case ReactionType.wow: return Paths.wowEmoji;
      case ReactionType.sad: return Paths.sadEmoji;
      case ReactionType.angry: return Paths.angryEmoji;
      case ReactionType.goal: return Paths.ballEmoji;
      case ReactionType.offside: return Paths.offsideEmoji;
      case ReactionType.none: return '';
    }
  }
}