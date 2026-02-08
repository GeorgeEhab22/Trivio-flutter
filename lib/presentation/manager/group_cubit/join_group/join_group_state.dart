import 'package:equatable/equatable.dart';

abstract class JoinGroupState extends Equatable {
  const JoinGroupState();

  @override
  List<Object?> get props => [];
}

class JoinGroupInitial extends JoinGroupState {
  const JoinGroupInitial();
}


class JoinGroupLoading extends JoinGroupState {
  const JoinGroupLoading();
}


class JoinGroupSuccess extends JoinGroupState {

  const JoinGroupSuccess();

}

class JoinGroupFailure extends JoinGroupState {
  final String message;
  final String? errorType;

  const JoinGroupFailure({
    required this.message,
    this.errorType,
  });

  @override
  List<Object?> get props => [message, errorType];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';
  bool get isServerError => errorType == 'server';
}