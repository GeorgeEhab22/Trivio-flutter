import 'package:equatable/equatable.dart';

abstract class CreateGroupState extends Equatable {
  const CreateGroupState();

  @override
  List<Object?> get props => [];
}

class CreateGroupInitial extends CreateGroupState {
  final String? nameError;
  final String? descError;
  const CreateGroupInitial({this.nameError, this.descError});
  @override
  List<Object?> get props => [nameError, descError];
}

class CreateGroupLoading extends CreateGroupState {
  const CreateGroupLoading();
}

class CreateGroupSuccess extends CreateGroupState {
  const CreateGroupSuccess();
}

class CreateGroupFailure extends CreateGroupState {
  final String message;
  final String? errorType;

  const CreateGroupFailure({required this.message, this.errorType});

  @override
  List<Object?> get props => [message, errorType];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';
  bool get isServerError => errorType == 'server';
}
