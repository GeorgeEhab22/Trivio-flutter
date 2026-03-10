import 'package:equatable/equatable.dart';

abstract class JoinGroupState extends Equatable {
  final Map<String, String> serverConfirmedRequests;

  const JoinGroupState({required this.serverConfirmedRequests});

  @override
  List<Object?> get props => [serverConfirmedRequests];
}

class JoinGroupInitial extends JoinGroupState {
  const JoinGroupInitial({required super.serverConfirmedRequests});
}

class JoinGroupLoading extends JoinGroupState {
  final String loadingGroupId;

  const JoinGroupLoading({
    required this.loadingGroupId,
    required super.serverConfirmedRequests,
  });

  @override
  List<Object?> get props => [loadingGroupId, serverConfirmedRequests];
}

class JoinGroupSuccess extends JoinGroupState {
  const JoinGroupSuccess({required super.serverConfirmedRequests});
}

class JoinGroupFailure extends JoinGroupState {
  final String message;
  final String errorType;

  const JoinGroupFailure({
    required this.message,
    required this.errorType,
    required super.serverConfirmedRequests,
  });

  @override
  List<Object?> get props => [message, errorType, serverConfirmedRequests];
}