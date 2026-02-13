class UserProfile {
  final String id;
  final String name;
  final String? email;
  final String? role;
  final String privacy;
  final int followersCount;
  final int followingCount;
  

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.privacy = "public",
    this.followersCount = 0,
    this.followingCount = 0,
  });
}
