import 'package:auth/domain/usecases/user_profile/get_liked.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_liked_posts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikedPostsCubit extends Cubit<LikedPostsState> {
  final GetLikedPostsIds getLikedPostsUseCase;

  LikedPostsCubit({required this.getLikedPostsUseCase}) : super(LikedPostsInitial());

  Future<void> fetchLikedPosts() async {
    emit(LikedPostsLoading());

    final result = await getLikedPostsUseCase();

    result.fold(
      (failure) => emit(LikedPostsError(failure.message)),
      (posts) => emit(LikedPostsLoaded(posts)),
    );
  }
}