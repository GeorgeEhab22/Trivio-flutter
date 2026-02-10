import 'package:auth/domain/entities/group_member.dart';
import 'package:equatable/equatable.dart';

abstract class GetModeratorsState extends Equatable {
  const GetModeratorsState();

  @override
  List<Object?> get props => [];
}

class GetModeratorsInitial extends GetModeratorsState {
  const GetModeratorsInitial();
}

class GetModeratorsLoading extends GetModeratorsState {
  const GetModeratorsLoading();
}

class GetModeratorsSuccess extends GetModeratorsState {
  final List<GroupMember> members;
  const GetModeratorsSuccess({required this.members});

  @override
  List<Object?> get props => [members];
}

class GetModeratorsFailure extends GetModeratorsState {
  final String message;
  final String? errorType;

  const GetModeratorsFailure({required this.message, this.errorType});

  @override
  List<Object?> get props => [message, errorType];
}