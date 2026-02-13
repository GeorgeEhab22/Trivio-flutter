import 'package:auth/domain/usecases/user_profile/get_my_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetMyProfile getMyProfile;

  ProfileCubit({required this.getMyProfile})
      : super(ProfileInitial());

  /// 🔹 Load profile
  Future<void> loadProfile() async {
    emit(ProfileLoading());

    final result = await getMyProfile();

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  /// 🔹 Optional: refresh profile without showing loading screen
  Future<void> refreshProfile() async {
    final result = await getMyProfile();

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }
}
