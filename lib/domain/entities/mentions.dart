import 'package:equatable/equatable.dart';

class Mentions extends Equatable {
  final List<String> userIds;
  final List<String> usernames;

  const Mentions({required this.userIds, required this.usernames});

  @override
  List<Object?> get props => [userIds, usernames];
}