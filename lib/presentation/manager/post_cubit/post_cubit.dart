import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/post/delete_post_usecase.dart';
import 'package:auth/domain/usecases/post/get_posts_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetPostsUseCase getPostsUseCase;
  final DeletePostUseCase deletePostUseCase;

  PostCubit({
    required this.getPostsUseCase,
    required this.deletePostUseCase,
  }) : super(PostInitial());

  List<Post> posts = [];
  int page = 1;
  bool isLoadingMore = false;

  Future<void> fetchPosts({bool refresh = false}) async {
    if (refresh) {
      posts = [];
      page = 1;
      emit(PostLoading());
    }

    final result = await getPostsUseCase(page: page, limit: 10);

    result.fold(
      (failure) {
        if (isClosed) return; 
        emit(PostError(failure.message));
      },
      (newPosts) {
        posts = newPosts;
        page++;
        if (isClosed) return; 
        emit(PostLoaded(List.from(posts)));
      },
    );
  }

  Future<void> loadMorePosts() async {
    if (isLoadingMore) return;

    isLoadingMore = true;
    emit(PostsLoadingMore(List.from(posts)));

    final result = await getPostsUseCase(page: page, limit: 10);

    isLoadingMore = false;

    result.fold(
      (failure) => emit(PostsLoadingMoreError(failure.message, List.from(posts))),
      (newPosts) {
        if (newPosts.isEmpty) {
          emit(PostLoaded(List.from(posts))); 
          return;
        }
        posts.addAll(newPosts);
        page++;
        emit(PostLoaded(List.from(posts)));
      },
    );
  }

  void addNewPostToFeed(Post newPost) {
    posts.insert(0, newPost);
    emit(PostLoaded(List.from(posts)));
  }

  Future<void> deletePost({required Post post}) async {
    final String postId = post.postID ?? '';
    emit(DeletePostLoading(postId: postId));

    final result = await deletePostUseCase(postId);

    result.fold(
      (failure) => emit(_mapDeleteFailureToState(failure, postId)),
      (_) {
        posts.removeWhere((item) => item.postID == postId);
        emit(PostLoaded(List.from(posts)));
        emit(DeletePostSuccess(post: post));
      },
    );
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
}