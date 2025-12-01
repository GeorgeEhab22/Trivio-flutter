import 'package:auth/domain/entities/post.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  // final FetchPostsUseCase fetchPostsUseCase;
  // final FetchSinglePostUseCase fetchSinglePostUseCase;
  // final SearchPostsUseCase searchPostsUseCase;
  PostCubit(
    // {
    // required this.fetchPostsUseCase,
    // required this.fetchSinglePostUseCase,
    // required this.searchPostsUseCase,
  // }
  ) : super(PostInitial());

  List<Post> posts = [];
  int page = 1;
  bool isLoadingMore = false;



final List<Post> _dummyPosts = [
    Post(
      id: '1',
      authorId: '101',
      authorName: 'Marcus Rashford',
      authorImage: 'assets/images/player1.png',
      content: "Thrilled with the team's performance today! The energy on the pitch was electric. Great win, and a huge thank you to the fans for their incredible support! ⚽ #ManUtd #FootballIsLife",
      imageUrl: 'assets/images/post1.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      comments: [], reactions: [],
    ),
    Post(
      id: '2',
      authorId: '102',
      authorName: 'LionessPride Official',
      authorImage: 'assets/images/player2.png',
      content: "What a spectacular match last night! The determination and skill shown by our squad were truly inspiring. Onwards and upwards! 💪 #WomensFootball",
      imageUrl: 'assets/images/post2.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      comments: [], reactions: [],
    ),
    Post(
      id: '3',
      authorId: '103',
      authorName: 'Marcus Rashford',
      authorImage: 'assets/images/player1.png',
      content: "Thrilled with the team's performance today! The energy on the pitch was electric. Great win...",
      imageUrl: 'assets/images/post1.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      comments: [], reactions: [],
    ),
  ];

  Future<void> fetchPosts({bool refresh = false}) async {
    if (refresh) {
      posts = [];
      page = 1;
      emit(PostLoading());
    }
    await Future.delayed(const Duration(seconds: 1));

    if (page == 1) {
      posts = List.from(_dummyPosts);
    } else {
      posts.addAll(_dummyPosts); 
    }
    
    page++;
    emit(PostLoaded(List.from(posts)));
  }

  Future<void> loadMorePosts() async {
    if (isLoadingMore) return;
    isLoadingMore = true;
    emit(PostsLoadingMore(posts));
    
    await Future.delayed(const Duration(seconds: 1)); 
    
    posts.addAll(_dummyPosts);
    page++;
    
    isLoadingMore = false;
    emit(PostLoaded(List.from(posts)));
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
