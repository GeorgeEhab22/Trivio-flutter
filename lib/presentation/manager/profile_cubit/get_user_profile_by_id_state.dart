import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/user_profile.dart';

abstract class GetUserProfileByIdState extends Equatable {
  const GetUserProfileByIdState();

  @override
  List<Object?> get props => [];
}

class GetUserProfileByIdInitial extends GetUserProfileByIdState {}

class GetUserProfileByIdLoading extends GetUserProfileByIdState {}

class GetUserProfileByIdLoaded extends GetUserProfileByIdState {
  final UserProfile user;

  const GetUserProfileByIdLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class GetUserProfileByIdError extends GetUserProfileByIdState {
  final String message;

  const GetUserProfileByIdError(this.message);

  @override
  List<Object?> get props => [message];
}