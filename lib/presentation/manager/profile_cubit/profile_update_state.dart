import 'package:equatable/equatable.dart';

abstract class ProfileUpdateState extends Equatable {
  const ProfileUpdateState();

  @override
  List<Object?> get props => [];
}

class ProfileUpdateInitial extends ProfileUpdateState {}

// Use this for both updating info and changing password
class ProfileUpdateLoading extends ProfileUpdateState {}

// Use this to show a success message or navigate back
class ProfileUpdateSuccess extends ProfileUpdateState {
  final String message;
  const ProfileUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateError extends ProfileUpdateState {
  final String message;
  const ProfileUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}