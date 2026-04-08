import 'package:equatable/equatable.dart';

abstract class CancelRequestGroupState extends Equatable {
  final String? groupId;
  const CancelRequestGroupState({this.groupId});

  @override
  List<Object?> get props => [groupId];
}

class CancelRequestGroupInitial extends CancelRequestGroupState {
  const CancelRequestGroupInitial();
}

class CancelRequestGroupLoading extends CancelRequestGroupState {
  const CancelRequestGroupLoading({super.groupId});
}

class CancelRequestGroupSuccess extends CancelRequestGroupState {
  const CancelRequestGroupSuccess({super.groupId});
}

class CancelRequestGroupFailure extends CancelRequestGroupState {
  final String message;
  final String? errorType;

  const CancelRequestGroupFailure({
    required this.message,
    this.errorType,
    super.groupId,
  });
  @override
  List<Object?> get props => [message, errorType, groupId];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';
  bool get isServerError => errorType == 'server';
}
