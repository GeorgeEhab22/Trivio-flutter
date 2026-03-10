import 'dart:convert';

import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/domain/usecases/post/delete_post_usecase.dart';
import 'package:auth/domain/usecases/post/get_post_reactions_usecase.dart';
import 'package:auth/domain/usecases/post/get_posts_usecase.dart';
import 'package:auth/domain/usecases/post/edit_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetPostsUseCase getPostsUseCase;
  final GetPostReactionsUseCase getPostReactionsUseCase;
  final DeletePostUseCase deletePostUseCase;
  final EditPostUseCase editPostUseCase;
  final SharedPreferences prefs;

  static const String _commentsCountFloorsPrefsKey =
      'post_comments_count_floors';
  static const String _commentsCountCeilingsPrefsKey =
      'post_comments_count_ceilings';
  static const String _reactionsSnapshotPrefsKey = 'post_reactions_snapshot';
  bool _isCommentsCountFloorsLoaded = false;
  bool _isCommentsCountCeilingsLoaded = false;
  bool _isReactionsSnapshotLoaded = false;
  final Map<String, int> _commentsCountFloors = {};
  final Map<String, int> _commentsCountCeilings = {};
  final Map<String, int> _cachedReactionsCount = {};
  final Map<String, ReactionType> _cachedUserReactions = {};
  final Set<String> _hydratedCurrentUserReactionPostIds = {};
  bool _isHydratingCurrentUserReactions = false;

  PostCubit({
    required this.getPostsUseCase,
    required this.getPostReactionsUseCase,
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
  int _normalizeReactionsCount(int count) => count < 0 ? 0 : count;

  void _ensureReactionsSnapshotLoaded() {
    if (_isReactionsSnapshotLoaded) return;
    _isReactionsSnapshotLoaded = true;

    final raw = prefs.getString(_reactionsSnapshotPrefsKey);
    if (raw == null || raw.trim().isEmpty) return;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return;

      decoded.forEach((postId, value) {
        if (postId.trim().isEmpty || value is! Map<String, dynamic>) {
          return;
        }

        final rawCount = value['count'];
        if (rawCount is int && rawCount >= 0) {
          _cachedReactionsCount[postId] = rawCount;
        } else if (rawCount is String) {
          final parsed = int.tryParse(rawCount);
          if (parsed != null && parsed >= 0) {
            _cachedReactionsCount[postId] = parsed;
          }
        }

        final rawReaction = value['reaction']?.toString();
        if (rawReaction == null || rawReaction.trim().isEmpty) {
          return;
        }
        final parsedReaction = _parseReactionType(rawReaction);
        _cachedUserReactions[postId] = parsedReaction;
        if (parsedReaction != ReactionType.none &&
            (_cachedReactionsCount[postId] ?? 0) == 0) {
          _cachedReactionsCount[postId] = 1;
        }
      });
    } catch (_) {
      _cachedReactionsCount.clear();
      _cachedUserReactions.clear();
    }
  }

  ReactionType _parseReactionType(String value) {
    try {
      return ReactionType.values.firstWhere(
        (type) => type.name == value.trim().toLowerCase(),
      );
    } catch (_) {
      return ReactionType.none;
    }
  }

  void _persistReactionsSnapshot() {
    final payload = <String, dynamic>{};
    final allPostIds = <String>{
      ..._cachedReactionsCount.keys,
      ..._cachedUserReactions.keys,
    };

    for (final postId in allPostIds) {
      payload[postId] = {
        'count': _cachedReactionsCount[postId] ?? 0,
        'reaction': (_cachedUserReactions[postId] ?? ReactionType.none).name,
      };
    }

    // ignore: discarded_futures
    prefs.setString(_reactionsSnapshotPrefsKey, jsonEncode(payload));
  }

  List<Post> _applyCommentsCountFloors(List<Post> source) {
    _ensureCommentsCountFloorsLoaded();
    _ensureCommentsCountCeilingsLoaded();

    var didMutateFloors = false;
    var didMutateCeilings = false;
    final updated = source.map((post) {
      final postId = post.postID;
      if ( postId.trim().isEmpty) {
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

  List<Post> _applyReactionSnapshot(List<Post> source) {
    _ensureReactionsSnapshotLoaded();

    var didMutateCache = false;
    final updated = source.map((post) {
      final postId = post.postID;
      if (postId.trim().isEmpty) {
        return post;
      }

      var resolvedCount = _normalizeReactionsCount(post.reactionsCount);
      var resolvedReaction = post.userReaction;

      final cachedCount = _cachedReactionsCount[postId];
      if (cachedCount != null) {
        if (resolvedCount == cachedCount) {
          _cachedReactionsCount.remove(postId);
          didMutateCache = true;
        } else {
          resolvedCount = cachedCount;
        }
      }

      final cachedReaction = _cachedUserReactions[postId];
      if (cachedReaction != null) {
        if (resolvedReaction == cachedReaction) {
          _cachedUserReactions.remove(postId);
          didMutateCache = true;
        } else if (resolvedReaction == ReactionType.none) {
          resolvedReaction = cachedReaction;
        } else {
          _cachedUserReactions.remove(postId);
          didMutateCache = true;
        }
      }

      if (resolvedReaction != ReactionType.none && resolvedCount == 0) {
        resolvedCount = 1;
      }

      return post.copyWith(
        reactionsCount: _normalizeReactionsCount(resolvedCount),
        userReaction: resolvedReaction,
      );
    }).toList();

    if (didMutateCache) {
      _persistReactionsSnapshot();
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
      _hydratedCurrentUserReactionPostIds.clear();
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
        posts = _applyReactionSnapshot(_applyCommentsCountFloors(newPosts));

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
        final normalizedNewPosts = _applyReactionSnapshot(
          _applyCommentsCountFloors(newPosts),
        );
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
    posts.insert(
      0,
      _applyReactionSnapshot(_applyCommentsCountFloors([newPost])).first,
    );
    final postId = newPost.postID.trim();
    if ( postId.isNotEmpty) {
      _hydratedCurrentUserReactionPostIds.remove(postId);
    }
    emit(PostLoaded(List.from(posts), hasReachedMax: hasReachedMax));
  }

  Future<void> hydrateCurrentUserReactions({
    required String currentUserId,
  }) async {
    final normalizedUserId = currentUserId.trim();
    if (normalizedUserId.isEmpty || _isHydratingCurrentUserReactions) {
      return;
    }

    final candidates = posts.where((post) {
      final postId = post.postID.trim();
      if ( postId.isEmpty) {
        return false;
      }
      if (_hydratedCurrentUserReactionPostIds.contains(postId)) {
        return false;
      }
      if (post.reactionsCount <= 0) {
        return false;
      }
      if (post.userReaction == ReactionType.none) {
        return true;
      }
      return !_hasCurrentUserReactionId(post, normalizedUserId);
    }).toList();

    if (candidates.isEmpty) {
      return;
    }

    _isHydratingCurrentUserReactions = true;
    var didMutate = false;

    for (final post in candidates) {
      final postId = post.postID.trim();
      if ( postId.isEmpty) {
        continue;
      }

      _hydratedCurrentUserReactionPostIds.add(postId);
      final result = await getPostReactionsUseCase(postId: postId);
      if (isClosed) {
        _isHydratingCurrentUserReactions = false;
        return;
      }

      result.fold((_) {}, (reactions) {
        Reaction? mine;
        for (final reaction in reactions.reversed) {
          if (reaction.userId == normalizedUserId &&
              reaction.type != ReactionType.none) {
            mine = reaction;
            break;
          }
        }
        if (mine == null) {
          return;
        }

        final postIndex = posts.indexWhere((item) => item.postID == postId);
        if (postIndex == -1) {
          return;
        }

        final currentPost = posts[postIndex];
        final updatedReactions = List<Reaction>.from(
          currentPost.reactions ?? const <Reaction>[],
        );
        final existingIndex = updatedReactions.indexWhere(
          (reaction) => reaction.userId == normalizedUserId,
        );
        if (existingIndex >= 0) {
          updatedReactions[existingIndex] = mine;
        } else {
          updatedReactions.add(mine);
        }

        final resolvedCount = currentPost.reactionsCount > 0
            ? currentPost.reactionsCount
            : reactions.length;

        posts[postIndex] = currentPost.copyWith(
          userReaction: mine.type,
          reactionsCount: resolvedCount,
          reactions: updatedReactions,
        );

        _ensureReactionsSnapshotLoaded();
        _cachedUserReactions[postId] = mine.type;
        _cachedReactionsCount[postId] = resolvedCount;
        didMutate = true;
      });
    }

    _isHydratingCurrentUserReactions = false;
    if (!didMutate) {
      return;
    }

    _persistReactionsSnapshot();
    emit(PostLoaded(List.from(posts), hasReachedMax: hasReachedMax));
  }

  bool _hasCurrentUserReactionId(Post post, String currentUserId) {
    final reactions = post.reactions;
    if (reactions == null || reactions.isEmpty) {
      return false;
    }
    for (final reaction in reactions.reversed) {
      if (reaction.userId != currentUserId) {
        continue;
      }
      final id = reaction.id.trim();
      if (id.isNotEmpty) {
        return true;
      }
    }
    return false;
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
    final nextCount = (currentCount + by).clamp(0, 1 << 31).toInt();
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

  void updatePostReaction({
    required String postId,
    String? currentUserId,
    required ReactionType reactionType,
    required int reactionsCount,
    String? reactionId,
  }) {
    if (postId.trim().isEmpty) {
      return;
    }

    final index = posts.indexWhere((p) => p.postID == postId);
    if (index == -1) {
      return;
    }

    var safeCount = reactionsCount < 0 ? 0 : reactionsCount;
    if (reactionType != ReactionType.none && safeCount == 0) {
      safeCount = 1;
    }

    final normalizedUserId = currentUserId?.trim() ?? '';
    final updatedReactions = List<Reaction>.from(
      posts[index].reactions ?? const <Reaction>[],
    );
    if (normalizedUserId.isNotEmpty) {
      final existingIndex = updatedReactions.indexWhere(
        (reaction) => reaction.userId == normalizedUserId,
      );
      if (reactionType == ReactionType.none) {
        if (existingIndex >= 0) {
          updatedReactions.removeAt(existingIndex);
        }
      } else {
        final previous = existingIndex >= 0 ? updatedReactions[existingIndex] : null;
        final normalizedReactionId = reactionId?.trim() ?? '';
        final resolvedReactionId = normalizedReactionId.isNotEmpty
            ? normalizedReactionId
            : (previous?.id ?? '');
        final resolvedPostId = previous?.postId.isNotEmpty == true
            ? previous!.postId
            : postId;
        final updated = Reaction(
          id: resolvedReactionId,
          userId: normalizedUserId,
          postId: resolvedPostId,
          type: reactionType,
          username: previous?.username,
          profilePicture: previous?.profilePicture,
        );
        if (existingIndex >= 0) {
          updatedReactions[existingIndex] = updated;
        } else {
          updatedReactions.add(updated);
        }
      }
    }

    posts[index] = posts[index].copyWith(
      reactionsCount: safeCount,
      userReaction: reactionType,
      reactions: updatedReactions,
    );
    _ensureReactionsSnapshotLoaded();
    _cachedReactionsCount[postId] = safeCount;
    _cachedUserReactions[postId] = reactionType;
    _persistReactionsSnapshot();

    emit(PostLoaded(List.from(posts), hasReachedMax: hasReachedMax));
  }

  Future<void> deletePost({required Post post}) async {
    final String postId = post.postID;
    emit(DeletePostLoading(postId: postId));
    final result = await deletePostUseCase(postId);
    if (isClosed) return;

    result.fold((failure) => emit(_mapDeleteFailureToState(failure, postId)), (
      _,
    ) {
      posts.removeWhere((item) => item.postID == postId);
      _ensureCommentsCountFloorsLoaded();
      _ensureCommentsCountCeilingsLoaded();
      _ensureReactionsSnapshotLoaded();
      final didRemoveFloor = _commentsCountFloors.remove(postId) != null;
      final didRemoveCeiling = _commentsCountCeilings.remove(postId) != null;
      final didRemoveReactionCount =
          _cachedReactionsCount.remove(postId) != null;
      final didRemoveReactionType = _cachedUserReactions.remove(postId) != null;
      if (didRemoveFloor) {
        _persistCommentsCountFloors();
      }
      if (didRemoveCeiling) {
        _persistCommentsCountCeilings();
      }
      if (didRemoveReactionCount || didRemoveReactionType) {
        _persistReactionsSnapshot();
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
          posts[index] = _applyReactionSnapshot(
            _applyCommentsCountFloors([updatedPost]),
          ).first;
        }

        emit(PostLoaded(List.from(posts), hasReachedMax: hasReachedMax));
        emit(EditPostSuccess(updatedPost: updatedPost));
      },
    );
  }
}
