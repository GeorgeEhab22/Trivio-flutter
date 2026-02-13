import 'package:auth/domain/entities/group.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class UpdateGroupState extends Equatable {
  const UpdateGroupState();
  @override
  List<Object?> get props => [];
}

class UpdateGroupInitial extends UpdateGroupState {
  final String? nameError;
  final String? descError;
  final XFile? groupCoverImage;
  const UpdateGroupInitial({this.nameError, this.descError, this.groupCoverImage});
  
  @override
  List<Object?> get props => [nameError, descError, groupCoverImage];
}

class UpdateGroupLoading extends UpdateGroupState {
  const UpdateGroupLoading();
}

class UpdateGroupSuccess extends UpdateGroupState {
  final Group group;
  const UpdateGroupSuccess({required this.group});
  @override
  List<Object?> get props => [group];
}

class UpdateGroupFailure extends UpdateGroupState {
  final String message;
  final String? errorType;

  const UpdateGroupFailure({required this.message, this.errorType});

  @override
  List<Object?> get props => [message, errorType];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';
  bool get isServerError => errorType == 'server';
}