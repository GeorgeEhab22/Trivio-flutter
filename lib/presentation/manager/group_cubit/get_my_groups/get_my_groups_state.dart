import 'package:auth/domain/entities/group.dart';
import 'package:equatable/equatable.dart';

abstract class GetMyGroupsState extends Equatable {
  const GetMyGroupsState();

  @override
  List<Object?> get props => [];
}

class GetMyGroupsInitial extends GetMyGroupsState {}

class GetMyGroupsLoading extends GetMyGroupsState {}

class GetMyGroupsLoaded extends GetMyGroupsState {
  final List<Group> groups;
  final bool hasReachedMax;

  const GetMyGroupsLoaded({required this.groups, this.hasReachedMax = false});

  @override
  List<Object?> get props => [groups, hasReachedMax];
}

class GetMyGroupsLoadingMore extends GetMyGroupsState {
  final List<Group> groups;
  const GetMyGroupsLoadingMore({required this.groups});

  @override
  List<Object?> get props => [groups];
}

class GetMyGroupsError extends GetMyGroupsState {
  final String message;
  final List<Group> groups;

  const GetMyGroupsError({required this.message, this.groups = const []});

  @override
  List<Object?> get props => [message, groups];
}