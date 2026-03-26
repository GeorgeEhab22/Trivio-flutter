import 'package:auth/domain/entities/post.dart';

abstract class ProfilePostsState {}

class ProfilePostsInitial extends ProfilePostsState {}

class ProfilePostsLoading extends ProfilePostsState {}

class ProfilePostsLoaded extends ProfilePostsState {
  final List<Post> myPosts;
  final List<Post> likedPosts;
  
  final bool isMyPostsLoading;
  final bool isLikedPostsLoading;

  ProfilePostsLoaded({
    this.myPosts = const [],
    this.likedPosts = const [],
    this.isMyPostsLoading = false,
    this.isLikedPostsLoading = false,
  });

  ProfilePostsLoaded copyWith({
    List<Post>? myPosts,
    List<Post>? likedPosts,
    bool? isMyPostsLoading,
    bool? isLikedPostsLoading,
  }) {
    return ProfilePostsLoaded(
      myPosts: myPosts ?? this.myPosts,
      likedPosts: likedPosts ?? this.likedPosts,
      isMyPostsLoading: isMyPostsLoading ?? this.isMyPostsLoading,
      isLikedPostsLoading: isLikedPostsLoading ?? this.isLikedPostsLoading,
    );
  }
}

class ProfilePostsFailure extends ProfilePostsState {
  final String message;
  ProfilePostsFailure(this.message);
}