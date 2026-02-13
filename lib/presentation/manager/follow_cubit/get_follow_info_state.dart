import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/follow.dart';

abstract class FollowInfoState extends Equatable {
  const FollowInfoState();

  @override
  List<Object?> get props => [];
}

class FollowInfoInitial extends FollowInfoState {}

class FollowInfoLoading extends FollowInfoState {}

class FollowInfoLoaded extends FollowInfoState {
  final List<Follow> data;
  final bool hasReachedMax;

  const FollowInfoLoaded({
    required this.data,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [data, hasReachedMax];
}

class FollowInfoFailure extends FollowInfoState {
  final String message;

  const FollowInfoFailure(this.message);

  @override
  List<Object?> get props => [message];
}
