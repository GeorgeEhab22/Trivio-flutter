import '../../domain/entities/user.dart';

class UserModel extends User {
  final String id;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required super.email,
    required super.username,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      isVerified: json['isVerfied'] ?? false, 
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'username': username,
      'isVerfied': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User toEntity() {
    return User(
      email: email,
      username: username,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: '',
      email: user.email,
      username: user.username,
      isVerified: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  ////////////////////////////////////////////////////////
  factory UserModel.empty() {
    return UserModel(
      id: '',
      email: '',
      username: '',
      isVerified: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}