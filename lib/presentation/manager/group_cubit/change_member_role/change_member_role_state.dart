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
  final String message;
  const ChangeMemberRoleSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ChangeMemberRoleFailure extends ChangeMemberRoleState {
  final String message;
  const ChangeMemberRoleFailure(this.message);
  @override
  List<Object?> get props => [message];
}