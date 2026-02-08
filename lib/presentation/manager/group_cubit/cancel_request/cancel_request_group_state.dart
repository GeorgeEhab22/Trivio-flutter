import 'package:equatable/equatable.dart';

abstract class CancelRequestGroupState extends Equatable {
  const CancelRequestGroupState();

  @override
  List<Object?> get props => [];
}

class CancelRequestGroupInitial extends CancelRequestGroupState {
  const CancelRequestGroupInitial();
}

class CancelRequestGroupLoading extends CancelRequestGroupState {
  const CancelRequestGroupLoading();
}

class CancelRequestGroupSuccess extends CancelRequestGroupState {
  const CancelRequestGroupSuccess();
}

class CancelRequestGroupFailure extends CancelRequestGroupState {
  final String message;
  final String? errorType;

  const CancelRequestGroupFailure({required this.message, this.errorType});

  @override
  List<Object?> get props => [message, errorType];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';
  bool get isServerError => errorType == 'server';
}
