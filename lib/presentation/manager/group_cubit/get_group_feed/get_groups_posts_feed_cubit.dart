import 'package:auth/domain/usecases/group/group_posts/get_groups_posts_feed_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_feed/get_groups_posts_feed_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/entities/post.dart';

class GetGroupsPostsFeedCubit extends Cubit<GetGroupsPostsFeedState> {
  final GetGroupsPostsFeedUseCase getGroupsPostsFeedUseCase;

  GetGroupsPostsFeedCubit({required this.getGroupsPostsFeedUseCase})
    : super(GetGroupsPostsFeedInitial());

  List<Post> allPosts = [];
  int currentPage = 1;
  bool isFetching = false;

  Future<void> fetchFeed({bool isRefresh = false}) async {
    if (isFetching) return;

    if (isRefresh) {
      currentPage = 1;
      allPosts = [];
      emit(GetGroupsPostsFeedLoading());
    }

    isFetching = true;
    final result = await getGroupsPostsFeedUseCase(page: currentPage);

    result.fold(
      (failure) {
        isFetching = false;
        emit(GetGroupsPostsFeedError(failure.message));
      },
      (newPosts) {
        isFetching = false;
        if (newPosts.isEmpty) {
          emit(GetGroupsPostsFeedLoaded(posts: allPosts, hasReachedMax: true));
        } else {
          allPosts.addAll(newPosts);
          currentPage++;
          emit(
            GetGroupsPostsFeedLoaded(
              posts: List.from(allPosts),
              hasReachedMax: false,
            ),
          );
        }
      },
    );
  }
}
