import 'package:equatable/equatable.dart';

abstract class LeaveGroupState extends Equatable {
  const LeaveGroupState();

  @override
  List<Object?> get props => [];
}

class LeaveGroupInitial extends LeaveGroupState {
  const LeaveGroupInitial();
}

class LeaveGroupLoading extends LeaveGroupState {
  const LeaveGroupLoading();
}

class LeaveGroupSuccess extends LeaveGroupState {
  final String groupId;
  const LeaveGroupSuccess({required this.groupId});
}

class LeaveGroupFailure extends LeaveGroupState {
  final String message;
  final String? errorType;

  const LeaveGroupFailure({required this.message, this.errorType});

  @override
  List<Object?> get props => [message, errorType];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';
  bool get isServerError => errorType == 'server';
}
