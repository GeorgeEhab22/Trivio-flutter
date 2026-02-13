import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/group.dart';

abstract class GetGroupsState extends Equatable {
  const GetGroupsState();
  @override
  List<Object?> get props => [];
}

class GetGroupsInitial extends GetGroupsState {}

class GetGroupsLoading extends GetGroupsState {}

class GetGroupsSuccess extends GetGroupsState {
  final List<Group> groups;
  const GetGroupsSuccess({required this.groups});

  @override
  List<Object?> get props => [groups];
}

class GetGroupsFailure extends GetGroupsState {
  final String message;
  const GetGroupsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}