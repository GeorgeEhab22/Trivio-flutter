import 'package:auth/domain/entities/group_member.dart';
import 'package:equatable/equatable.dart';

abstract class GetBannedMembersState extends Equatable {
  const GetBannedMembersState();
  @override
  List<Object?> get props => [];
}

class GetBannedMembersInitial extends GetBannedMembersState {
  const GetBannedMembersInitial();
}

class GetBannedMembersLoading extends GetBannedMembersState {
  const GetBannedMembersLoading();
}

class GetBannedMembersSuccess extends GetBannedMembersState {
  final List<GroupMember> bannedMembers;
  const GetBannedMembersSuccess({required this.bannedMembers});
  @override
  List<Object?> get props => [bannedMembers];
}

class GetBannedMembersFailure extends GetBannedMembersState {
  final String message;
  final String? errorType;
  const GetBannedMembersFailure({required this.message, this.errorType});
  @override
  List<Object?> get props => [message, errorType];
}
