import 'dart:io';
import 'package:auth/domain/usecases/user_profile/change_password.dart';
import 'package:auth/domain/usecases/user_profile/update_profile.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_update_state.dart';

class ProfileUpdateCubit extends Cubit<ProfileUpdateState> {
  final UpdateProfile updateProfileUseCase;
  final ChangePassword changePasswordUseCase;

  ProfileUpdateCubit({
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
    String? initialName,
    String? initialBio,
    String? initialAvatar,
  }) : super(ProfileUpdateInitialState(
          name: initialName ?? '',
          bio: initialBio ?? '',
          originalAvatar: initialAvatar??'',
        ));

  // --- Mock Update Profile logic ---
  Future<void> submitUpdate() async {
    if (state is! ProfileUpdateInitialState) return;
    final draft = state as ProfileUpdateInitialState;
    emit(ProfileUpdateLoading());
    await Future.delayed(const Duration(seconds: 2));
    final String imagePath = draft.image?.path ?? draft.originalAvatar;
    ProfileCubit.updateMockData(draft.name, draft.bio, imagePath);
    emit(const ProfileUpdateSuccess("Profile updated successfully (Mock)!"));
  }

  void onInfoChanged({String? name, String? bio, File? image}) {
    if (state is ProfileUpdateInitialState) {
      emit((state as ProfileUpdateInitialState).copyWith(
        name: name,
        bio: bio,
        image: image,
      ));
    }
  }

  void updateImage(File imageFile) => onInfoChanged(image: imageFile);
}