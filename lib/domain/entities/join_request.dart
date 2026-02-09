import 'package:equatable/equatable.dart';

class JoinRequest extends Equatable {
  final String requestId;
  final String groupId;
  final String userId;
  final String userName;
  final String userEmail;
  final String status;

  const JoinRequest({
    required this.requestId,
    required this.groupId,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.status,
  });

  @override
  List<Object?> get props => [requestId, groupId, userId, status];
}