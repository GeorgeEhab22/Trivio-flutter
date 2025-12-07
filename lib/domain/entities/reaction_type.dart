enum ReactionType {
  none, 
  goal,
  offside, 
}
class DummyReactionCounter{
  final int likesCount;
  final int lovesCount;
  final int hahaCount;
  final int sadCount;
  final int angryCount;
  final int wowCount; 

  DummyReactionCounter({
    required this.likesCount,
    required this.lovesCount,
    required this.hahaCount,
    required this.sadCount,
    required this.angryCount,
    required this.wowCount
  });
}