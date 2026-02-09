import 'package:auth/domain/entities/join_request.dart';
import 'package:equatable/equatable.dart';

abstract class GetJoinRequestsState extends Equatable {
  const GetJoinRequestsState();

  @override
  List<Object?> get props => [];
}

class GetJoinRequestsInitial extends GetJoinRequestsState {
  const GetJoinRequestsInitial();
}

class GetJoinRequestsLoading extends GetJoinRequestsState {
  const GetJoinRequestsLoading();
}

class GetJoinRequestsSuccess extends GetJoinRequestsState {
  final List<JoinRequest> requests;
  const GetJoinRequestsSuccess({required this.requests});

  @override
  List<Object?> get props => [requests];
}
class GetJoinRequestsEmpty extends GetJoinRequestsState {
  const GetJoinRequestsEmpty();
}
class GetJoinRequestsFailure extends GetJoinRequestsState {
  final String message;
  final String? errorType;

  const GetJoinRequestsFailure({required this.message, this.errorType});

  @override
  List<Object?> get props => [message, errorType];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';
  bool get isServerError => errorType == 'server';
}
