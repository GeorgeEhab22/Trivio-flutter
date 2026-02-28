import 'dart:convert';

import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/post/delete_post_usecase.dart';
import 'package:auth/domain/usecases/post/get_posts_usecase.dart';
import 'package:auth/domain/usecases/post/edit_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetPostsUseCase getPostsUseCase;
  final DeletePostUseCase deletePostUseCase;
  final EditPostUseCase editPostUseCase;
  final SharedPreferences prefs;

  static const String _commentsCountFloorsPrefsKey =
      'post_comments_count_floors_v1';
  bool _isCommentsCountFloorsLoaded = false;
  final Map<String, int> _commentsCountFloors = {};

  PostCubit({
    required this.getPostsUseCase,
    required this.deletePostUseCase,
    required this.editPostUseCase,
    required this.prefs,
  }) : super(PostInitial());

  List<Post> posts = [];
  int page = 1;
  bool isLoadingMore = false;
  bool hasReachedMax = false; // Track if we finished all posts

  void _ensureCommentsCountFloorsLoaded() {
    if (_isCommentsCountFloorsLoaded) return;
    _isCommentsCountFloorsLoaded = true;

    final raw = prefs.getString(_commentsCountFloorsPrefsKey);
    if (raw == null || raw.trim().isEmpty) return;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return;

      decoded.forEach((key, value) {
        if (value is int && value >= 0) {
          _commentsCountFloors[key] = value;
          return;
        }
        if (value is String) {
          final parsed = int.tryParse(value);
          if (parsed != null && parsed >= 0) {
            _commentsCountFloors[key] = parsed;
          }
        }
      });
    } catch (_) {
      _commentsCountFloors.clear();
    }
  }

  void _persistCommentsCountFloors() {
    // ignore: discarded_futures
    prefs.setString(
      _commentsCountFloorsPrefsKey,
      jsonEncode(_commentsCountFloors),
    );
  }

  List<Post> _applyCommentsCountFloors(List<Post> source) {
    _ensureCommentsCountFloorsLoaded();

    var didMutateFloors = false;
    final updated = source.map((post) {
      final postId = post.postID;
      if (postId == null || postId.trim().isEmpty) {
        return post;
      }

      final floor = _commentsCountFloors[postId];
      if (floor == null) {
        return post;
      }

      if (post.commentsCount >= floor) {
        _commentsCountFloors.remove(postId);
        didMutateFloors = true;
        return post;
      }

      return post.copyWith(commentsCount: floor);
    }).toList();

    if (didMutateFloors) {
      _persistCommentsCountFloors();
    }
    return updated;
  }

  void _setCommentsCountFloor(String postId, int floorValue) {
    _ensureCommentsCountFloorsLoaded();

    final previousFloor = _commentsCountFloors[postId] ?? 0;
    if (floorValue <= previousFloor) {
      return;
    }

    _commentsCountFloors[postId] = floorValue;
    _persistCommentsCountFloors();
  }

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
        posts = _applyCommentsCountFloors(newPosts);

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
        final normalizedNewPosts = _applyCommentsCountFloors(newPosts);
        if (newPosts.isEmpty) {
          hasReachedMax = true;
          emit(PostLoaded(List.from(posts), hasReachedMax: true));
          return;
        }

        final existingIds = posts.map((p) => p.postID).toSet();
        final uniqueNewPosts = normalizedNewPosts
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
    posts.insert(0, _applyCommentsCountFloors([newPost]).first);
    emit(PostLoaded(List.from(posts), hasReachedMax: hasReachedMax));
  }

  void incrementCommentsCount(String postId, {int by = 1}) {
    if (postId.trim().isEmpty || by == 0) {
      return;
    }

    final index = posts.indexWhere((p) => p.postID == postId);
    if (index == -1) {
      return;
    }

    final currentPost = posts[index];
    final nextCount = (currentPost.commentsCount + by)
        .clamp(0, 1 << 31)
        .toInt();
    posts[index] = currentPost.copyWith(commentsCount: nextCount);
    _setCommentsCountFloor(postId, nextCount);
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
