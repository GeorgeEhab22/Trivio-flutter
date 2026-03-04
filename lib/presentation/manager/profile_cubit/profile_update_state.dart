import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProfileUpdateState extends Equatable {
  const ProfileUpdateState();
  @override
  List<Object?> get props => [];
}

/// This state holds the current values in the form
class ProfileUpdateInitialState extends ProfileUpdateState {
  final String name;
  final String bio;
  final File? image;
  final String originalAvatar;

  const ProfileUpdateInitialState({
    this.name = '',
    this.bio = '',
    this.image, 
    this.originalAvatar='',
  });

  ProfileUpdateInitialState copyWith({
    String? name,
    String? bio,
    File? image,
    String? originalAvatar,
  }) {
    return ProfileUpdateInitialState(
      name: name ?? this.name,
      bio: bio ?? this.bio,
      image: image ?? this.image,
      originalAvatar: originalAvatar ?? this.originalAvatar,
    );
  }
  String get avatarPath => image != null ? image!.path : originalAvatar;
  @override
  List<Object?> get props => [name, bio, image, originalAvatar];
}

class ProfileUpdateLoading extends ProfileUpdateState {}

class ProfileUpdateSuccess extends ProfileUpdateState {
  final String message;
  const ProfileUpdateSuccess(this.message);
}

class ProfileUpdateError extends ProfileUpdateState {
  final String message;
  const ProfileUpdateError(this.message);
}