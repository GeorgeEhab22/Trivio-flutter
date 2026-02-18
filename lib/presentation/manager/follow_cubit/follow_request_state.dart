import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/follow_request.dart';

abstract class FollowRequestState extends Equatable {
  const FollowRequestState();

  @override
  List<Object?> get props => [];
}

class FollowRequestInitial extends FollowRequestState {}

class FollowRequestLoading extends FollowRequestState {}

class FollowRequestLoaded extends FollowRequestState {
  final List<FollowRequest> requests;

  const FollowRequestLoaded(this.requests);

  @override
  List<Object?> get props => [requests];
}

class FollowRequestActionSuccess extends FollowRequestState {
  final String message;

  const FollowRequestActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class FollowRequestFailure extends FollowRequestState {
  final String message;

  const FollowRequestFailure(this.message);

  @override
  List<Object?> get props => [message];
}
