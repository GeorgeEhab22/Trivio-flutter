import 'package:equatable/equatable.dart';

abstract class UnbanMemberState extends Equatable {
  const UnbanMemberState();
  @override
  List<Object?> get props => [];
}

class UnbanMemberInitial extends UnbanMemberState {
  const UnbanMemberInitial();
}

class UnbanMemberLoading extends UnbanMemberState {
  const UnbanMemberLoading();
}

class UnbanMemberSuccess extends UnbanMemberState {
  final String message;
  final String userId;
  const UnbanMemberSuccess(this.message, this.userId);
  @override
  List<Object?> get props => [message, userId];
}

class UnbanMemberFailure extends UnbanMemberState {
  final String message;
  const UnbanMemberFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
