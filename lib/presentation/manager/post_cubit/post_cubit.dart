import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/post/delete_post_usecase.dart';
import 'package:auth/domain/usecases/post/get_posts_usecase.dart';
import 'package:auth/domain/usecases/post/edit_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetPostsUseCase getPostsUseCase;
  final DeletePostUseCase deletePostUseCase;
  final EditPostUseCase editPostUseCase;

  PostCubit({
    required this.getPostsUseCase,
    required this.deletePostUseCase,
    required this.editPostUseCase,
  }) : super(PostInitial());

  List<Post> posts = [];
  int page = 1;
  bool isLoadingMore = false;
  bool hasReachedMax = false; // Track if we finished all posts

  Future<void> fetchPosts({bool refresh = false}) async {
    if (refresh) {
      posts = [];
      page = 1;
      hasReachedMax = false;
      emit(PostLoading());
    }

    final result = await getPostsUseCase(page: page, limit: 10);

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(PostError(failure.message));
      },
      (newPosts) {
        if (isClosed) return;
        posts = newPosts;

        if (newPosts.isEmpty) {
          hasReachedMax = true;
        } else {
          page++;
        }

        emit(PostLoaded(List.from(posts), hasReachedMax: hasReachedMax));
      },
    );
  }

  Future<void> loadMorePosts() async {
    if (isLoadingMore || hasReachedMax) return;

    isLoadingMore = true;
    emit(PostsLoadingMore(List.from(posts)));

    final result = await getPostsUseCase(page: page, limit: 10);
    if (isClosed) return;
    isLoadingMore = false;

    result.fold(
      (failure) {
        emit(PostsLoadingMoreError(failure.message, List.from(posts)));
      },
      (newPosts) {
        if (newPosts.isEmpty) {
          hasReachedMax = true;
          emit(PostLoaded(List.from(posts), hasReachedMax: true));
          return;
        }

        final existingIds = posts.map((p) => p.postID).toSet();
        final uniqueNewPosts = newPosts
            .where((p) => !existingIds.contains(p.postID))
            .toList();

        if (uniqueNewPosts.isNotEmpty) {
          posts.addAll(uniqueNewPosts);
          page++; 
        } else {
          hasReachedMax = true;
        }

        emit(PostLoaded(List.from(posts), hasReachedMax: hasReachedMax));
      },
    );
  }

  void addNewPostToFeed(Post newPost) {
    posts.insert(0, newPost);
    emit(PostLoaded(List.from(posts), hasReachedMax: hasReachedMax));
  }

  Future<void> deletePost({required Post post}) async {
    final String postId = post.postID ?? '';
    emit(DeletePostLoading(postId: postId));
    final result = await deletePostUseCase(postId);
    if (isClosed) return;

    result.fold((failure) => emit(_mapDeleteFailureToState(failure, postId)), (
      _,
    ) {
      posts.removeWhere((item) => item.postID == postId);
      emit(PostLoaded(List.from(posts), hasReachedMax: hasReachedMax));
      emit(DeletePostSuccess(post: post));
    });
  }

  DeletePostError _mapDeleteFailureToState(Failure failure, String postId) {
    String errorType = 'server';
    if (failure is ValidationFailure) errorType = 'validation';
    if (failure is NetworkFailure) errorType = 'network';

    return DeletePostError(
      postId: postId,
      message: failure.message,
      errorType: errorType,
    );
  }

  Future<void> editPost({
    required String postId,
    String? newCaption,
    String? newType,
  }) async {
    emit(EditPostLoading(postId: postId));

    final result = await editPostUseCase(postId: postId, caption: newCaption);
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(EditPostError(postId: postId, message: failure.message)),
      (updatedPost) {
        final index = posts.indexWhere((p) => p.postID == postId);
        if (index != -1) {
          posts[index] = updatedPost;
        }

        emit(PostLoaded(List.from(posts), hasReachedMax: hasReachedMax));
        emit(EditPostSuccess(updatedPost: updatedPost));
      },
    );
  }
}
