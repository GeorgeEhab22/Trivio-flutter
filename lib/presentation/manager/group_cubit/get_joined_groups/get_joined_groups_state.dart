
import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/group.dart';

abstract class GetJoinedGroupsState extends Equatable {
  const GetJoinedGroupsState();
  @override
  List<Object?> get props => [];
}

class GetJoinedGroupsInitial extends GetJoinedGroupsState {}
class GetJoinedGroupsLoading extends GetJoinedGroupsState {}

class GetJoinedGroupsSuccess extends GetJoinedGroupsState {
  final List<Group> groups;
  const GetJoinedGroupsSuccess({required this.groups});
  @override
  List<Object?> get props => [groups];
}

class GetJoinedGroupsFailure extends GetJoinedGroupsState {
  final String message;
  const GetJoinedGroupsFailure({required this.message});
  @override
  List<Object?> get props => [message];
}