import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/group/group_posts/delete_group_post_use_case.dart';
import 'package:auth/domain/usecases/group/group_posts/edit_group_post_use_case.dart';
import 'package:auth/domain/usecases/group/group_posts/get_group_posts_use_case.dart';
import 'package:auth/domain/usecases/group/group_posts/get_groups_posts_feed_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_state.dart';

class GroupPostsCubit extends Cubit<GroupPostsState> {
  final GetGroupPostsUseCase getGroupPostsUseCase;
  final GetGroupsPostsFeedUseCase getGroupsPostsFeedUseCase;
  final DeleteGroupPostUseCase deleteGroupPostUseCase;
  final EditGroupPostUseCase editGroupPostUseCase;

  GroupPostsCubit({
    required this.getGroupPostsUseCase,
    required this.getGroupsPostsFeedUseCase,
    required this.deleteGroupPostUseCase,
    required this.editGroupPostUseCase,
  }) : super(const GroupPostsInitial());

  List<Post> posts = [];
  int page = 1;
  bool hasReachedMax = false;
  String? currentGroupId;

  Future<void> getFeedPosts({bool refresh = false}) async {
    if (state is GroupPostsLoading || state is GroupPostsLoadingMore) return;

    if (refresh) _resetPagination();

    if (posts.isEmpty) emit(const GroupPostsLoading());

    final result = await getGroupsPostsFeedUseCase(page: 1);

    result.fold((failure) => emit(GroupPostsError(failure.message)), (
      serverPosts,
    ) {
      if (isClosed) return;

      final serverMap = {for (var p in serverPosts) p.postID: p};
      final serverIds = serverMap.keys.toSet();

      posts = posts.map((p) => serverMap[p.postID] ?? p).toList();
      posts.removeWhere(
        (p) =>
            !serverIds.contains(p.postID) &&
            posts.indexOf(p) < serverPosts.length,
      );

      final currentIds = posts.map((p) => p.postID).toSet();
      final trulyNew = serverPosts
          .where((p) => !currentIds.contains(p.postID))
          .toList();

      if (trulyNew.isNotEmpty) {
        posts.insertAll(0, trulyNew);
      }

      hasReachedMax = serverPosts.isEmpty;

      if (refresh || posts.length <= serverPosts.length) {
        page = hasReachedMax ? 1 : 2;
      }

      emit(GroupPostsLoaded(List.from(posts), hasReachedMax: hasReachedMax));
    });
  }

  Future<void> loadMoreFeedPosts() async {
    if (state is GroupPostsLoadingMore ||
        state is GroupPostsLoading ||
        hasReachedMax) {
      return;
    }
    emit(GroupPostsLoadingMore(List.from(posts)));

    final result = await getGroupsPostsFeedUseCase(page: page);

    result.fold(
      (failure) =>
          emit(GroupPostsLoadingMoreError(failure.message, List.from(posts))),
      (newPosts) {
        if (isClosed) return;

        if (newPosts.isEmpty) {
          hasReachedMax = true;
        } else {
          final existingIds = posts.map((p) => p.postID).toSet();
          final uniquePosts = newPosts
              .where((p) => !existingIds.contains(p.postID))
              .toList();

          if (uniquePosts.isEmpty) {
            hasReachedMax = true;
          } else {
            posts.addAll(uniquePosts);
            page++;
          }
        }

        emit(GroupPostsLoaded(List.from(posts), hasReachedMax: hasReachedMax));
      },
    );
  }

  Future<void> getPosts({required String groupId, bool refresh = false}) async {
    if (state is GroupPostsLoadingMore ||
        state is GroupPostsLoading ||
        (hasReachedMax && !refresh)) {
      return;
    }
    currentGroupId = groupId;
    if (refresh) _resetPagination();

    if (posts.isEmpty) {
      emit(const GroupPostsLoading());
    } else {
      emit(GroupPostsLoadingMore(List.from(posts)));
    }

    final result = await getGroupPostsUseCase(groupId: groupId, page: page);

    result.fold((failure) {
      if (posts.isEmpty) {
        emit(GroupPostsError(failure.message));
      } else {
        emit(GroupPostsLoadingMoreError(failure.message, List.from(posts)));
      }
    }, (newPosts) => _handleSuccess(newPosts));
  }

  void _handleSuccess(List<Post> newPosts) {
    if (isClosed) return;

    if (newPosts.isEmpty) {
      hasReachedMax = true;
    } else {
      final existingIds = posts.map((p) => p.postID).toSet();
      final uniquePosts = newPosts
          .where((p) => !existingIds.contains(p.postID))
          .toList();

      posts.addAll(uniquePosts);
      page++;
    }

    emit(GroupPostsLoaded(List.from(posts), hasReachedMax: hasReachedMax));
  }

  void addPostOptimistically(Post post) {
    posts.insert(0, post);
    emit(GroupPostsLoaded(List.from(posts), hasReachedMax: hasReachedMax));
  }

  Future<void> editPost({
    required String groupId,
    required String postId,
    required String newCaption,
  }) async {
    emit(GroupPostsEditing(postId: postId));

    final result = await editGroupPostUseCase(
      groupId: groupId,
      postId: postId,
      newCaption: newCaption,
    );

    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(GroupPostsEditError(postId: postId, message: failure.message)),
      (updatedPost) {
        final index = posts.indexWhere((p) => p.postID == postId);
        if (index != -1) {
          posts[index] = updatedPost;
          emit(
            GroupPostsLoaded(List.from(posts), hasReachedMax: hasReachedMax),
          );
          emit(GroupPostsEditSuccess(updatedPost: updatedPost));
        }
      },
    );
  }

  Future<void> deletePost({required String groupId, required Post post}) async {
    final String postId = post.postID;
    final backupPosts = List<Post>.from(posts);

    emit(GroupPostsDeleting(postId: postId));
    posts.removeWhere((item) => item.postID == postId);
    emit(GroupPostsLoaded(List.from(posts), hasReachedMax: hasReachedMax));

    final result = await deleteGroupPostUseCase(
      groupId: groupId,
      postId: postId,
    );

    if (isClosed) return;

    result.fold((failure) {
      posts = backupPosts;
      emit(GroupPostsLoaded(List.from(posts), hasReachedMax: hasReachedMax));
      emit(GroupPostsError(failure.message));
    }, (_) => emit(GroupPostsDeleteSuccess(post: post)));
  }

  void _resetPagination() {
    posts.clear();
    page = 1;
    hasReachedMax = false;
  }
}
