import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/user_profile/get_liked_posts.dart';
import 'package:auth/domain/usecases/user_profile/get_my_posts.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_posts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePostsCubit extends Cubit<ProfilePostsState> {
  final GetMyPostsUseCase getMyPostsUseCase;
  final GetLikedPostsUseCase getLikedPostsUseCase;

  ProfilePostsCubit({
    required this.getMyPostsUseCase,
    required this.getLikedPostsUseCase,
  }) : super(ProfilePostsInitial());

// Inside ProfilePostsCubit
Future<void> fetchAllProfileData() async {
  emit(ProfilePostsLoading());

  // Run both, but handle them so one crash doesn't stop the other
  final results = await Future.wait([
    getMyPostsUseCase.call(),
    getLikedPostsUseCase.call(),
  ]);

  final myPostsResult = results[0];
  final likedPostsResult = results[1];

  List<Post> myPosts = [];
  List<Post> likedPosts = [];
  String? errorMessage;

  myPostsResult.fold(
    (f) => errorMessage = f.message, 
    (p) => myPosts = p
  );
  
  likedPostsResult.fold(
    (f) => errorMessage = f.message, 
    (p) => likedPosts = p
  );

  if (myPosts.isEmpty && likedPosts.isEmpty && errorMessage != null) {
    emit(ProfilePostsFailure(errorMessage!));
  } else {
    emit(ProfilePostsLoaded(
      myPosts: myPosts,
      likedPosts: likedPosts,
    ));
  }
}

  Future<void> refreshMyPosts() async {
    if (state is ProfilePostsLoaded) {
      final currentState = state as ProfilePostsLoaded;
      emit(currentState.copyWith(isMyPostsLoading: true));

      final result = await getMyPostsUseCase.call();
      result.fold(
        (failure) => emit(ProfilePostsFailure(failure.message)),
        (posts) => emit(currentState.copyWith(
          myPosts: posts,
          isMyPostsLoading: false,
        )),
      );
    }
  }
}