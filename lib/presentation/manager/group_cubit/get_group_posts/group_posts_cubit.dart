import 'package:auth/domain/usecases/group/group_posts/delete_group_post_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/group/group_posts/get_group_posts_use_case.dart';

class GroupPostsCubit extends Cubit<GroupPostsState> {
  final GetGroupPostsUseCase getGroupPostsUseCase;
  final DeleteGroupPostUseCase deleteGroupPostUseCase;

  GroupPostsCubit({
    required this.getGroupPostsUseCase,
    required this.deleteGroupPostUseCase,
  }) : super(GroupPostsInitial());

  List<Post> posts = [];
  int page = 1;
  bool isFetching = false;

  Future<void> getPosts({required String groupId, bool refresh = false}) async {
    if (isFetching) return;

    if (refresh) {
      page = 1;
      posts = [];
      emit(GroupPostsLoading());
    }

    isFetching = true;

    final result = await getGroupPostsUseCase(groupId: groupId, page: page);

    result.fold(
      (failure) {
        isFetching = false;
        emit(GroupPostsError(failure.message));
      },
      (newPosts) {
        isFetching = false;
        if (newPosts.isEmpty && page > 1) {
          emit(GroupPostsLoaded(List.from(posts)));
          return;
        }

        posts.addAll(newPosts);
        page++;
        emit(GroupPostsLoaded(List.from(posts)));
      },
    );
  }

  Future<void> deletePost({required String groupId, required Post post}) async {
    final String postId = post.postID ?? '';
emit(GroupPostsDeleting(postId: postId));

    final result = await deleteGroupPostUseCase(
      groupId: groupId,
      postId: postId,
    );

    result.fold(
      (failure) => {
        emit(GroupPostsError(failure.message)),
      },
      (successMessage) {
        posts.removeWhere((item) => item.postID == postId);

        emit(GroupPostsLoaded(List.from(posts)));
      },
    );
  }

  void addPostOptimistically(Post post) {
    posts.insert(0, post);
    emit(GroupPostsLoaded(List.from(posts)));
  }
}
