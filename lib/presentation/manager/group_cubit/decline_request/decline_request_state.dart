import 'package:equatable/equatable.dart';

abstract class DeclineRequestState extends Equatable {
  const DeclineRequestState();

  @override
  List<Object?> get props => [];
}

class DeclineRequestInitial extends DeclineRequestState {
  const DeclineRequestInitial();
}

class DeclineRequestLoading extends DeclineRequestState {
  const DeclineRequestLoading();
}

class DeclineRequestSuccess extends DeclineRequestState {
  final String requestId;
  const DeclineRequestSuccess(this.requestId);
  @override
  List<Object?> get props => [requestId];
}

class DeclineRequestFailure extends DeclineRequestState {
  final String message;
  final String? errorType;

  const DeclineRequestFailure({required this.message, this.errorType});

  @override
  List<Object?> get props => [message, errorType];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';
  bool get isServerError => errorType == 'server';
}
