class UserProfilePreview {
  final String id;
  final String name;
  final String? avatarUrl;

  UserProfilePreview({
    required this.id,
    required this.name,
    this.avatarUrl,
  });
}