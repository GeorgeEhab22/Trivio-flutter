import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/post/fetch_posts_usecase.dart';
import 'package:auth/domain/usecases/post/fetch_single_post_usecase.dart';
// import 'package:auth/domain/usecases/post/search_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final FetchPostsUseCase fetchPostsUseCase;
  final FetchSinglePostUseCase fetchSinglePostUseCase;
  // final SearchPostsUseCase searchPostsUseCase;
  PostCubit({
    required this.fetchPostsUseCase,
    required this.fetchSinglePostUseCase,
    // required this.searchPostsUseCase,
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
    final result = await fetchPostsUseCase(page: page, limit: 20);

    result.fold((failure) => emit(PostError(failure.message)), (fetchPosts) {
      posts.addAll(fetchPosts);
      page++;
      emit(PostLoaded(List.from(posts)));
    });
    // Implementation for fetching posts
  }

  Future<void> loadMorePosts() async {
    if (isLoadingMore) return;
    isLoadingMore = true;
    emit(PostsLoadingMore(posts));
    final result = await fetchPostsUseCase(page: page, limit: 20);
    isLoadingMore = false;
    result.fold(
      (failure) =>
          emit(PostsLoadingMoreError(failure.message, List.from(posts))),
      (fetchPosts) {
        if (fetchPosts.isEmpty) return;

        posts.addAll(fetchPosts);
        page++;

        emit(PostLoaded(List.from(posts)));
      },
    );
  }

  Future<void> fetchSinglePost(String postId) async {
    emit(const PostLoading());
    final result = await fetchSinglePostUseCase(postId);
    result.fold((failure) => emit(PostError(failure.message)), (post) {
      emit(PostsSingleLoaded(post));
    });
  }
}
