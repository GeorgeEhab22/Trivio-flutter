import 'package:equatable/equatable.dart';

abstract class JoinGroupState extends Equatable {
  final String? groupId; 

  const JoinGroupState({this.groupId});

  @override
  List<Object?> get props => [groupId];
}

class JoinGroupInitial extends JoinGroupState {
  const JoinGroupInitial();
}

class JoinGroupLoading extends JoinGroupState {
  const JoinGroupLoading({super.groupId});
}

class JoinGroupSuccess extends JoinGroupState {
  const JoinGroupSuccess({super.groupId});
}

class JoinRequestRemovedLocally extends JoinGroupState {
  const JoinRequestRemovedLocally({required super.groupId});
  @override
  List<Object?> get props => [groupId];
}

class JoinGroupFailure extends JoinGroupState {
  final String message;
  final String? errorType;

  const JoinGroupFailure({
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