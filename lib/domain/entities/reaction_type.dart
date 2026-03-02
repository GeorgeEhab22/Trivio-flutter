enum ReactionType { none, like, love, haha, wow, sad, angry, goal, offside }

class DummyReactionCounter {
  final int likesCount;
  final int lovesCount;
  final int hahaCount;
  final int sadCount;
  final int angryCount;
  final int wowCount;
  final int goalCount;
  final int offsideCount;

  DummyReactionCounter({
    required this.likesCount,
    required this.lovesCount,
    required this.hahaCount,
    required this.sadCount,
    required this.angryCount,
    required this.wowCount,
    required this.goalCount,
    required this.offsideCount,
  });

  int get total =>
      likesCount +
      lovesCount +
      hahaCount +
      wowCount +
      sadCount +
      angryCount +
      goalCount +
      offsideCount;
}
