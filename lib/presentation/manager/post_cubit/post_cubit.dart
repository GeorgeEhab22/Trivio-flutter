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
      'post_comments_count_floors_v2';
  static const String _commentsCountCeilingsPrefsKey =
      'post_comments_count_ceilings_v2';
  bool _isCommentsCountFloorsLoaded = false;
  bool _isCommentsCountCeilingsLoaded = false;
  final Map<String, int> _commentsCountFloors = {};
  final Map<String, int> _commentsCountCeilings = {};

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

  void _ensureCommentsCountCeilingsLoaded() {
    if (_isCommentsCountCeilingsLoaded) return;
    _isCommentsCountCeilingsLoaded = true;

    final raw = prefs.getString(_commentsCountCeilingsPrefsKey);
    if (raw == null || raw.trim().isEmpty) return;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return;

      decoded.forEach((key, value) {
        if (value is int && value >= 0) {
          _commentsCountCeilings[key] = value;
          return;
        }
        if (value is String) {
          final parsed = int.tryParse(value);
          if (parsed != null && parsed >= 0) {
            _commentsCountCeilings[key] = parsed;
          }
        }
      });
    } catch (_) {
      _commentsCountCeilings.clear();
    }
  }

  void _persistCommentsCountCeilings() {
    // ignore: discarded_futures
    prefs.setString(
      _commentsCountCeilingsPrefsKey,
      jsonEncode(_commentsCountCeilings),
    );
  }

  int _normalizeCommentsCount(int count) => count < 0 ? 0 : count;

  List<Post> _applyCommentsCountFloors(List<Post> source) {
    _ensureCommentsCountFloorsLoaded();
    _ensureCommentsCountCeilingsLoaded();

    var didMutateFloors = false;
    var didMutateCeilings = false;
    final updated = source.map((post) {
      final postId = post.postID;
      if (postId == null || postId.trim().isEmpty) {
        return post;
      }

      var resolvedPost = post.copyWith(
        commentsCount: _normalizeCommentsCount(post.commentsCount),
      );

      final floor = _commentsCountFloors[postId];
      if (floor != null) {
        if (resolvedPost.commentsCount >= floor) {
          _commentsCountFloors.remove(postId);
          didMutateFloors = true;
        } else {
          resolvedPost = resolvedPost.copyWith(commentsCount: floor);
        }
      }

      final ceiling = _commentsCountCeilings[postId];
      if (ceiling != null) {
        if (resolvedPost.commentsCount <= ceiling) {
          _commentsCountCeilings.remove(postId);
          didMutateCeilings = true;
        } else {
          resolvedPost = resolvedPost.copyWith(commentsCount: ceiling);
        }
      }

      return resolvedPost.copyWith(
        commentsCount: _normalizeCommentsCount(resolvedPost.commentsCount),
      );
    }).toList();

    if (didMutateFloors) {
      _persistCommentsCountFloors();
    }
    if (didMutateCeilings) {
      _persistCommentsCountCeilings();
    }
    return updated;
  }

  void _setCommentsCountFloor(
    String postId,
    int floorValue, {
    bool allowLower = false,
  }) {
    _ensureCommentsCountFloorsLoaded();

    final previousFloor = _commentsCountFloors[postId] ?? 0;
    if (!allowLower && floorValue <= previousFloor) {
      return;
    }
    if (allowLower && floorValue == previousFloor) {
      return;
    }

    _commentsCountFloors[postId] = floorValue;
    _persistCommentsCountFloors();
  }

  void _setCommentsCountCeiling(String postId, int ceilingValue) {
    _ensureCommentsCountCeilingsLoaded();

    final previousCeiling = _commentsCountCeilings[postId];
    if (previousCeiling != null && ceilingValue >= previousCeiling) {
      return;
    }

    _commentsCountCeilings[postId] = ceilingValue;
    _persistCommentsCountCeilings();
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
    final currentCount = _normalizeCommentsCount(currentPost.commentsCount);
    final nextCount = (currentCount + by)
        .clamp(0, 1 << 31)
        .toInt();
    posts[index] = currentPost.copyWith(commentsCount: nextCount);
    if (by > 0) {
      _ensureCommentsCountCeilingsLoaded();
      final didRemoveCeiling = _commentsCountCeilings.remove(postId) != null;
      if (didRemoveCeiling) {
        _persistCommentsCountCeilings();
      }
      _setCommentsCountFloor(postId, nextCount);
    } else {
      _setCommentsCountFloor(postId, nextCount, allowLower: true);
      _setCommentsCountCeiling(postId, nextCount);
    }
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
      _ensureCommentsCountFloorsLoaded();
      _ensureCommentsCountCeilingsLoaded();
      final didRemoveFloor = _commentsCountFloors.remove(postId) != null;
      final didRemoveCeiling = _commentsCountCeilings.remove(postId) != null;
      if (didRemoveFloor) {
        _persistCommentsCountFloors();
      }
      if (didRemoveCeiling) {
        _persistCommentsCountCeilings();
      }
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
