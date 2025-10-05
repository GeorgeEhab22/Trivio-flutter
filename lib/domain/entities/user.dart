import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? avatar;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, email, username, avatar];
}