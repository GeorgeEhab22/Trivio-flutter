import 'package:equatable/equatable.dart';

abstract class AcceptRequestState extends Equatable {
  const AcceptRequestState();

  @override
  List<Object?> get props => [];
}

class AcceptRequestInitial extends AcceptRequestState {
  const AcceptRequestInitial();
}

class AcceptRequestLoading extends AcceptRequestState {
  const AcceptRequestLoading();
}

class AcceptRequestSuccess extends AcceptRequestState {
  const AcceptRequestSuccess();
}

class AcceptRequestFailure extends AcceptRequestState {
  final String message;
  final String? errorType;

  const AcceptRequestFailure({required this.message, this.errorType});

  @override
  List<Object?> get props => [message, errorType];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';
  bool get isServerError => errorType == 'server';
}
