import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/follow.dart';

abstract class FollowState extends Equatable {
  const FollowState();

  @override
  List<Object?> get props => [];
}

class FollowInitial extends FollowState {}

class FollowLoading extends FollowState {}

class FollowSuccess extends FollowState {
  final Follow? follow; // null when unfollow

  const FollowSuccess({this.follow});

  @override
  List<Object?> get props => [follow];
}

class FollowFailure extends FollowState {
  final String message;

  const FollowFailure(this.message);

  @override
  List<Object?> get props => [message];
}
