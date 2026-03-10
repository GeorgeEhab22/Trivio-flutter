import 'package:auth/domain/entities/group.dart';
import 'package:equatable/equatable.dart';

abstract class GetAllGroupsState extends Equatable {
  const GetAllGroupsState();

  @override
  List<Object?> get props => [];
}

class GetAllGroupsInitial extends GetAllGroupsState {}

class GetAllGroupsLoading extends GetAllGroupsState {}

class GetAllGroupsLoaded extends GetAllGroupsState {
  final List<Group> groups;
  final bool hasReachedMax;

  const GetAllGroupsLoaded({required this.groups, this.hasReachedMax = false});

  @override
  List<Object?> get props => [groups, hasReachedMax];
}

class GetAllGroupsLoadingMore extends GetAllGroupsState {
  final List<Group> groups;
  const GetAllGroupsLoadingMore({required this.groups});

  @override
  List<Object?> get props => [groups];
}

class GetAllGroupsError extends GetAllGroupsState {
  final String message;
  final List<Group> groups;

  const GetAllGroupsError({required this.message, this.groups = const []});

  @override
  List<Object?> get props => [message, groups];
}