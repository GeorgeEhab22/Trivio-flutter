import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.email,
    required super.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
  
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
      email: user.email,
      username: user.username,
      
    );
  }
}