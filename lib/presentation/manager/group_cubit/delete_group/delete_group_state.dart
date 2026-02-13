import 'package:equatable/equatable.dart';

abstract class DeleteGroupState extends Equatable {
  const DeleteGroupState();
  @override
  List<Object?> get props => [];
}

class DeleteGroupInitial extends DeleteGroupState {
  const DeleteGroupInitial();

}
class DeleteGroupLoading extends DeleteGroupState {
  const DeleteGroupLoading();

}
class DeleteGroupSuccess extends DeleteGroupState {
  final String message;
  const DeleteGroupSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class DeleteGroupFailure extends DeleteGroupState {
  final String message;
  final String? errorType;

  const DeleteGroupFailure({required this.message, this.errorType});

  @override
  List<Object?> get props => [message, errorType];
}