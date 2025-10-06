import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String username;

  const User({
    required this.email,
    required this.username,
  });

  @override
  List<Object?> get props => [email, username];
}