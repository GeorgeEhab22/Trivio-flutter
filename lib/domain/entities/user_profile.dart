class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String? bio;
  final int followersCount;
  final int followingCount;

  final List<String> favTeams;
  final List<String> favPlayers;
  
  final int postsCount;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    this.bio,
    this.followersCount = 0,
    this.followingCount = 0,
    this.favTeams = const [],
    this.favPlayers = const [],
    this.postsCount = 0,
  });
}
