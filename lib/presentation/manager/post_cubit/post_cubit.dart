import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/post/delete_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final DeletePostUseCase deletePostUseCase;
  PostCubit(this.deletePostUseCase) : super(PostInitial());

  List<Post> posts = [];
  int page = 1;
  bool isLoadingMore = false;

  List<Post> _dummyPosts() {
    return List.generate(3, (index) {
      return Post(
        postID: '$index',
        authorId: 'user_1',
        type: 'public',
        //authorName: 'Marcus Rashford',
        //authorImage: 'assets/images/player1.png',
        caption:
            "Thrilled with the team's performance today! The energy on the pitch was electric. Great win, and a huge thank you to the fans for their incredible support! ⚽ #ManUtd #FootballIsLife",
        //imageUrl: 'assets/images/post1.png',
        //createdAt: DateTime.now().subtract(Duration(hours: index)),
        //comments: const [],
        //reactions: const [],
        //isSaved: false,
        //isEdited: false,
      );
    });
  }
  // TODO:handle later , will be added to feed after refreshingggg
  void addNewPostToFeed(Post newPost) {
    posts.insert(0, newPost);

    emit(PostLoaded(List.from(posts)));
  }

  Future<void> fetchPosts({bool refresh = false}) async {
    final dummyPosts = _dummyPosts();
    if (refresh) {
      posts = [];
      page = 1;
      emit(PostLoading());
    }
    await Future.delayed(const Duration(seconds: 1));

    if (page == 1) {
      posts = List.from(dummyPosts);
    } else {
      posts.addAll(dummyPosts);
    }

    page++;
    emit(PostLoaded(List.from(posts)));
  }

  Future<void> loadMorePosts() async {
    final dummyPosts = _dummyPosts();

    if (isLoadingMore) return;
    isLoadingMore = true;
    emit(PostsLoadingMore(posts));

    await Future.delayed(const Duration(seconds: 1));

    posts.addAll(dummyPosts);
    page++;

    isLoadingMore = false;
    emit(PostLoaded(List.from(posts)));
  }

  // delete post
  Future<void> deletePost({required Post post}) async {
    emit(DeletePostLoading(postId: post.postID ?? ''));

    final result = await deletePostUseCase(post.postID ?? '');

    result.fold(
      (failure) => emit(_mapDeleteFailureToState(failure, post.postID ?? '')),
      (_) {
        // remove the deleted post from the list <==
        posts.removeWhere((item) => item.postID == post.postID);
        emit(PostLoaded(List.from(posts)));
        emit(DeletePostSuccess(post: post));
      },
    );
  }

  DeletePostError _mapDeleteFailureToState(Failure failure, String postId) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return DeletePostError(
          postId: postId,
          message: failure.message,
          errorType: 'validation',
        );
      case const (NetworkFailure):
        return DeletePostError(
          postId: postId,
          message: failure.message,
          errorType: 'network',
        );
      default:
        return DeletePostError(
          postId: postId,
          message: failure.message,
          errorType: 'server',
        );
    }
  }
  // up is dummy data , down is original code for now

  // Future<void> fetchPosts({bool refresh = false}) async {
  //   if (refresh) {
  //     posts = [];
  //     page = 1;
  //     emit(PostLoading());
  //   }
  //   final result = await fetchPostsUseCase(page: page, limit: 20);

  //   result.fold((failure) => emit(PostError(failure.message)), (fetchPosts) {
  //     posts.addAll(fetchPosts);
  //     page++;
  //     emit(PostLoaded(List.from(posts)));
  //   });
  //   // Implementation for fetching posts
  // }

  // Future<void> loadMorePosts() async {
  //   if (isLoadingMore) return;
  //   isLoadingMore = true;
  //   emit(PostsLoadingMore(posts));
  //   final result = await fetchPostsUseCase(page: page, limit: 20);
  //   isLoadingMore = false;
  //   result.fold(
  //     (failure) =>
  //         emit(PostsLoadingMoreError(failure.message, List.from(posts))),
  //     (fetchPosts) {
  //       if (fetchPosts.isEmpty) return;

  //       posts.addAll(fetchPosts);
  //       page++;

  //       emit(PostLoaded(List.from(posts)));
  //     },
  //   );
  // }

  // Future<void> fetchSinglePost(String postId) async {
  //   emit(const PostLoading());
  //   final result = await fetchSinglePostUseCase(postId);
  //   result.fold((failure) => emit(PostError(failure.message)), (post) {
  //     emit(PostsSingleLoaded(post));
  //   });
  // }
}
