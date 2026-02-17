import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/group.dart';

abstract class GetMyGroupsState extends Equatable {
  const GetMyGroupsState();
  @override
  List<Object?> get props => [];
}

class GetMyGroupsInitial extends GetMyGroupsState {}
class GetMyGroupsLoading extends GetMyGroupsState {}

class GetMyGroupsSuccess extends GetMyGroupsState {
  final List<Group> groups;
  const GetMyGroupsSuccess({required this.groups});
  @override
  List<Object?> get props => [groups];
}

class GetMyGroupsFailure extends GetMyGroupsState {
  final String message;
  const GetMyGroupsFailure({required this.message});
  @override
  List<Object?> get props => [message];
}