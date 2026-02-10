import 'package:auth/domain/entities/group_member.dart';
import 'package:equatable/equatable.dart';

abstract class GetMembersState extends Equatable {
  const GetMembersState();

  @override
  List<Object?> get props => [];
}

class GetMembersInitial extends GetMembersState {
  const GetMembersInitial();
}

class GetMembersLoading extends GetMembersState {
  const GetMembersLoading();
}

class GetMembersSuccess extends GetMembersState {
  final List<GroupMember> members;
  const GetMembersSuccess({required this.members});

  @override
  List<Object?> get props => [members];
}

class GetMembersFailure extends GetMembersState {
  final String message;
  final String? errorType;

  const GetMembersFailure({required this.message, this.errorType});

  @override
  List<Object?> get props => [message, errorType];
}