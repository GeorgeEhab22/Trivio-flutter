import 'package:auth/domain/usecases/user_profile/change_password.dart';
import 'package:auth/domain/usecases/user_profile/update_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
    // final String imagePath = draft.image?.path ?? draft.originalAvatar;
    // ProfileCubit.updateMockData(draft.name, draft.bio, imagePath);
    // emit(const ProfileUpdateSuccess("Profile updated successfully (Mock)!"));
    final result = await updateProfileUseCase.call(
      username: draft.name,
      bio: draft.bio,
      avatarFile: draft.image,
    );

    if (isClosed) return;
    
    result.fold(
      (failure) => emit(ProfileUpdateError(failure.message)),
      (success) => emit(const ProfileUpdateSuccess("Profile updated successfully!")),
    );
  }

  void onInfoChanged({String? name, String? bio, XFile? image}) {
    final currentState = state;
    if (currentState is ProfileUpdateInitialState) {
      emit(currentState.copyWith(
        name: name ?? currentState.name,
        bio: bio ?? currentState.bio,
        image: image ?? currentState.image,
      ));
    }
  }

  void updateImage(XFile imageFile) => onInfoChanged(image: imageFile);
}