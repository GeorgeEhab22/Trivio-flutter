enum UserPrivacy {
  private,
  public,
}

UserPrivacy? userPrivacyFromString(String? value) {
  if (value == null) return null;
  return UserPrivacy.values.firstWhere(
    (e) => e.name == value,
    orElse: () => UserPrivacy.public,
  );
}

String? userPrivacyToString(UserPrivacy? privacy) {
  return privacy?.name;
}

class UserProfileModel {
  final String id;
  final String username;
  final String email;
  final String role;
  final bool isVerified;
  final bool isPremium;

  final int? following;
  final int? followers;
  final int? posts;

  final List<String>? favTeams;
  final UserPrivacy? privacy;

  final DateTime? passwordChangedAt;
  final DateTime? codeCreatedAt;
  final DateTime? otpCreatedAt;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.isPremium,
    this.following,
    this.followers,
    this.posts,
    this.favTeams,
    this.privacy,
    this.passwordChangedAt,
    this.codeCreatedAt,
    this.otpCreatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'] ?? json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      isVerified: json['isVerified'] ?? false,
      isPremium: json['isPremium'] ?? false,
      following: json['following'],
      followers: json['followers'],
      posts: json['posts'],
      favTeams: json['favTeams'] != null
          ? List<String>.from(json['favTeams'])
          : null,
      privacy: userPrivacyFromString(json['privacy']),
      passwordChangedAt: json['passwordChangedAt'] != null
          ? DateTime.parse(json['passwordChangedAt'])
          : null,
      codeCreatedAt: json['codeCreatedAt'] != null
          ? DateTime.parse(json['codeCreatedAt'])
          : null,
      otpCreatedAt: json['OTPCreatedAt'] != null
          ? DateTime.parse(json['OTPCreatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'isVerified': isVerified,
      'isPremium': isPremium,
      'following': following,
      'followers': followers,
      'posts': posts,
      'favTeams': favTeams,
      'privacy': userPrivacyToString(privacy),
      'passwordChangedAt': passwordChangedAt?.toIso8601String(),
      'codeCreatedAt': codeCreatedAt?.toIso8601String(),
      'OTPCreatedAt': otpCreatedAt?.toIso8601String(),
    };
  }
}
