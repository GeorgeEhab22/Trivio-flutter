// lib/presentation/manager/profile_cubit/other_user_posts_cubit.dart
import 'package:auth/domain/usecases/user_profile/get_user_posts.dart';
import 'package:auth/presentation/manager/profile_cubit/user/get_user_posts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class GetUserPostsCubit extends Cubit<GetUserPostsState> {
  final GetUserPostsUseCase getUserPostsUseCase;

  GetUserPostsCubit({required this.getUserPostsUseCase}) 
      : super(GetUserPostsInitial());

  Future<void> fetchUserPosts(String userId) async {
    emit(GetUserPostsLoading());

    final result = await getUserPostsUseCase(userId);

    result.fold(
      (failure) => emit(GetUserPostsError(failure.message)),
      (posts) => emit(GetUserPostsLoaded(posts)),
    );
  }
}