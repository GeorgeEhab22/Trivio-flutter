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
    String? initialName, // Add these
    String? initialBio,
  }) : super(ProfileUpdateInitialState(
          name: initialName ?? '',
          bio: initialBio ?? '',
        ));

  /// 🔹 Update internal draft state as user types
  void onInfoChanged({String? name, String? bio, File? image}) {
    if (state is ProfileUpdateInitialState) {
      emit((state as ProfileUpdateInitialState).copyWith(
        name: name,
        bio: bio,
        image: image,
      ));
    }
  }

  /// 🔹 Submit the current draft to the API
  Future<void> submitUpdate() async {
    if (state is! ProfileUpdateInitialState) return;
    
    final draft = state as ProfileUpdateInitialState;
    emit(ProfileUpdateLoading());

    final result = await updateProfileUseCase(
      username: draft.name,
      bio: draft.bio,
      avatarFile: draft.image,
    );

    result.fold(
      (failure) => emit(ProfileUpdateError(failure.message)),
      (_) => emit(const ProfileUpdateSuccess("Profile updated successfully!")),
    );
  }

  // Helper to just update the image
  void updateImage(File imageFile) => onInfoChanged(image: imageFile);
}