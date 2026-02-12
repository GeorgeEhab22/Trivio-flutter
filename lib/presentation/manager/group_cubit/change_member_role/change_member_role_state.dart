import 'package:equatable/equatable.dart';

abstract class ChangeMemberRoleState extends Equatable {
  const ChangeMemberRoleState();
  @override
  List<Object?> get props => [];
}

class ChangeMemberRoleInitial extends ChangeMemberRoleState {
  const ChangeMemberRoleInitial();
}

class ChangeMemberRoleLoading extends ChangeMemberRoleState {
  const ChangeMemberRoleLoading();
}

class ChangeMemberRoleSuccess extends ChangeMemberRoleState {
  final String userId;
  final String newRole;
  final String message;
  const ChangeMemberRoleSuccess(this.message, this.userId, this.newRole);
  @override
  List<Object?> get props => [message, userId];
}

class ChangeMemberRoleFailure extends ChangeMemberRoleState {
  final String message;
  const ChangeMemberRoleFailure(this.message);
  @override
  List<Object?> get props => [message];
}