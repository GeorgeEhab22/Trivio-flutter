import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/group.dart';

abstract class GetGroupState extends Equatable {
  const GetGroupState();
  @override
  List<Object?> get props => [];
}

class GetGroupInitial extends GetGroupState {}

class GetGroupLoading extends GetGroupState {}

class GetGroupSuccess extends GetGroupState {
  final Group group;
  const GetGroupSuccess({required this.group});

  @override
  List<Object?> get props => [group];
}

class GetGroupFailure extends GetGroupState {
  final String message;
  const GetGroupFailure({required this.message});

  @override
  List<Object?> get props => [message];
}