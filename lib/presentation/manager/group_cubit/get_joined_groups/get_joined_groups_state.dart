
import 'package:auth/domain/entities/group.dart';
import 'package:equatable/equatable.dart';

abstract class GetJoinedGroupsState extends Equatable {
  const GetJoinedGroupsState();

  @override
  List<Object?> get props => [];
}

class GetJoinedGroupsInitial extends GetJoinedGroupsState {}

class GetJoinedGroupsLoading extends GetJoinedGroupsState {}

class GetJoinedGroupsLoaded extends GetJoinedGroupsState {
  final List<Group> groups;
  final bool hasReachedMax;

  const GetJoinedGroupsLoaded({required this.groups, this.hasReachedMax = false});

  @override
  List<Object?> get props => [groups, hasReachedMax];
}

class GetJoinedGroupsLoadingMore extends GetJoinedGroupsState {
  final List<Group> groups;
  const GetJoinedGroupsLoadingMore({required this.groups});

  @override
  List<Object?> get props => [groups];
}

class GetJoinedGroupsError extends GetJoinedGroupsState {
  final String message;
  final List<Group> groups;

  const GetJoinedGroupsError({required this.message, this.groups = const []});

  @override
  List<Object?> get props => [message, groups];
}