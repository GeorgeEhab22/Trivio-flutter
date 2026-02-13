import 'package:auth/domain/entities/group.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class CreateGroupState extends Equatable {
  const CreateGroupState();

  @override
  List<Object?> get props => [];
}

class CreateGroupInitial extends CreateGroupState {
  final String? nameError;
  final String? descError;
  final XFile? groupCoverImage;
  const CreateGroupInitial({this.nameError, this.descError, this.groupCoverImage});
  @override
  List<Object?> get props => [nameError, descError, groupCoverImage];
}

class CreateGroupLoading extends CreateGroupState {
  const CreateGroupLoading();
}

class CreateGroupSuccess extends CreateGroupState {
  final Group group;
  const CreateGroupSuccess({required this.group});
  @override
  List<Object?> get props => [group];
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
