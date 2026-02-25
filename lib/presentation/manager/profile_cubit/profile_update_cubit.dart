import 'dart:io';
import 'package:auth/domain/usecases/user_profile/change_password.dart';
import 'package:auth/domain/usecases/user_profile/update_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_update_state.dart';

class ProfileUpdateCubit extends Cubit<ProfileUpdateState> {
  final UpdateProfile updateProfileUseCase;
  final ChangePassword changePasswordUseCase;

  ProfileUpdateCubit({
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
  }) : super(ProfileUpdateInitial());

  /// 🔹 Update Name, Bio, or Avatar
  Future<void> updateProfileInfo({String? name, String? bio, File? image}) async {
    emit(ProfileUpdateLoading());

    final result = await updateProfileUseCase(
      username: name,
      bio: bio,
      avatarFile: image,
    );

    result.fold(
      (failure) => emit(ProfileUpdateError(failure.message)),
      (_) => emit(const ProfileUpdateSuccess("Profile updated successfully!")),
    );
  }

  /// 🔹 Change Password
  Future<void> updatePassword(String current, String next) async {
    emit(ProfileUpdateLoading());

    final result = await changePasswordUseCase(current, next);

    result.fold(
      (failure) => emit(ProfileUpdateError(failure.message)),
      (_) => emit(const ProfileUpdateSuccess("Password changed successfully!")),
    );
  }
}