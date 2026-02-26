import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/domain/usecases/user_profile/get_my_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetMyProfile getMyProfile;

  ProfileCubit({required this.getMyProfile}) : super(ProfileInitial());

  // 🔹 Local "Database" to keep track of changes during the app session
  static UserProfile _mockUser = const UserProfile(
    id: "123",
    name: "Menna (Mock)",
    bio: "Computer Science Student at Ain Shams University",
     avatar: "https://www.themarysue.com/wp-content/uploads/2012/01/TWSbatmanPrincess.png?resize=291%2C243",
     email: 'menna@@@',
     followersCount: 123,
     followingCount: 222,
     postsCount: 93
  );

  static void updateMockData(String name, String bio) {
    _mockUser = UserProfile(
      id: _mockUser.id,
      name: name,
      bio: bio,
      avatar: _mockUser.avatar,
      followersCount: _mockUser.followersCount,
      followingCount: _mockUser.followingCount,
      postsCount: _mockUser.postsCount, email: 'wre',
    );
  }

  /// 🔹 Mock Load Profile
  Future<void> loadProfile() async {
    emit(ProfileLoading());

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Instead of calling the usecase, we use our mock data
    // To test error UI, you can comment this and emit ProfileError
    emit(ProfileLoaded(_mockUser));
  }

}