import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/entities/comment_history.dart';
import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/usecases/comment/add_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/edit_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/get_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/get_comment_reactions_usecase.dart';
import 'package:auth/domain/usecases/comment/get_comments_usecase.dart';
import 'package:auth/domain/usecases/comment/get_replies_usecase.dart';
import 'package:auth/domain/usecases/comment/mention_users_in_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/react_to_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/remove_reaction_from_comment_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final GetCommentsUseCase getCommentsUseCase;
  final GetCommentUseCase getCommentUseCase;
  final GetCommentReactionsUseCase getCommentReactionsUseCase;
  final AddCommentUseCase addCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;
  final EditCommentUseCase editCommentUseCase;
  final GetRepliesUseCase getRepliesUseCase;
  final MentionUsersInCommentUseCase mentionUsersInCommentUseCase;
  final ReactToCommentUseCase reactToCommentUseCase;
  final RemoveReactionFromCommentUseCase removeReactionFromCommentUseCase;

  CommentCubit({
    required this.getCommentsUseCase,
    required this.getCommentUseCase,
    required this.getCommentReactionsUseCase,
    required this.addCommentUseCase,
    required this.deleteCommentUseCase,
    required this.editCommentUseCase,
    required this.getRepliesUseCase,
    required this.mentionUsersInCommentUseCase,
    required this.reactToCommentUseCase,
    required this.removeReactionFromCommentUseCase,
  }) : super(CommentInitial());

  List<Comment> _allComments = [];
  Comment? _replyingTo;
  Comment? _editingComment;
  final Set<String> _expandedReplyParentIds = {};
  final Set<String> _loadingReplyParentIds = {};
  final Map<String, String> _reactionIdsByComment = {};
  final Set<String> _hydratedCurrentUserReactionCommentIds = {};
  bool _isHydratingCurrentUserReactions = false;
  bool _pendingHydrationPass = false;

  Comment? get replyingTo => _replyingTo;
  Comment? get editingComment => _editingComment;
  bool isRepliesExpanded(String parentCommentId) =>
      _expandedReplyParentIds.contains(parentCommentId);
  bool isRepliesLoading(String parentCommentId) =>
      _loadingReplyParentIds.contains(parentCommentId);

  Future<void> getComments(
    String postId, {
    int? page,
    int? limit,
    String? sort,
    String? fields,
    String? keyword,
  }) async {
    _reactionIdsByComment.clear();
    _hydratedCurrentUserReactionCommentIds.clear();
    _expandedReplyParentIds.clear();
    _loadingReplyParentIds.clear();
    _replyingTo = null;
    _editingComment = null;
    emit(CommentLoading(_getStructuredComments()));

    final result = await getCommentsUseCase(
      postId,
      page: page,
      limit: limit,
      sort: sort,
      fields: fields,
      keyword: keyword,
    );
    await result.fold(
      (failure) async {
        emit(
          CommentError(
            _resolveErrorMessage(failure.message, fallbackKey: "load_failed"),
          ),
        );
      },
      (comments) async {
        _allComments = comments;
        await _hydrateRepliesOnOpen();
        _emitLoaded();
      },
    );
  }

  Future<void> _hydrateRepliesOnOpen() async {
    final parentComments = _allComments
        .where((c) => c.parentCommentId == null)
        .toList();

    for (final parent in parentComments) {
      final repliesResult = await getRepliesUseCase(
        parent.id,
        page: 1,
        limit: 50,
      );

      repliesResult.fold((_) {}, (replies) {
        for (final reply in replies) {
          final normalizedReply = _forceParentId(reply, parent.id);
          _upsertComment(normalizedReply);
        }
      });
    }
  }

  Future<void> hydrateCurrentUserReactions({
    required String currentUserId,
  }) async {
    final normalizedUserId = currentUserId.trim();
    if (normalizedUserId.isEmpty) {
      return;
    }
    if (_isHydratingCurrentUserReactions) {
      _pendingHydrationPass = true;
      return;
    }

    final candidates = _allComments.where((comment) {
      final commentId = comment.id.trim();
      if (commentId.isEmpty) {
        return false;
      }
      if (_hydratedCurrentUserReactionCommentIds.contains(commentId)) {
        return false;
      }
      if (comment.userReaction == ReactionType.none) {
        return true;
      }
      return !_hasCurrentUserReactionId(comment, normalizedUserId);
    }).toList();

    if (candidates.isEmpty) {
      return;
    }

    _isHydratingCurrentUserReactions = true;
    var didMutate = false;

    for (final comment in candidates) {
      final commentId = comment.id.trim();
      if (commentId.isEmpty) {
        continue;
      }

      final result = await getCommentReactionsUseCase(commentId: commentId);
      if (isClosed) {
        _isHydratingCurrentUserReactions = false;
        return;
      }

      result.fold((_) {}, (reactions) {
        _hydratedCurrentUserReactionCommentIds.add(commentId);

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

        final index = _allComments.indexWhere((item) => item.id == commentId);
        if (index == -1) {
          return;
        }

        final currentComment = _allComments[index];
        final updatedReactions = List<Reaction>.from(currentComment.reactions);
        final existingIndex = updatedReactions.indexWhere(
          (reaction) => reaction.userId == normalizedUserId,
        );
        if (existingIndex >= 0) {
          updatedReactions[existingIndex] = mine;
        } else {
          updatedReactions.add(mine);
        }

        final resolvedCount = currentComment.reactionsCount > 0
            ? currentComment.reactionsCount
            : reactions.length;

        _allComments[index] = currentComment.copyWith(
          reactions: updatedReactions,
          reactionsCount: resolvedCount,
          userReaction: mine.type,
        );

        final normalizedReactionId = _normalizeReactionIdForApi(mine.id);
        if (normalizedReactionId != null) {
          _reactionIdsByComment[commentId] = normalizedReactionId;
        }
        didMutate = true;
      });
    }

    _isHydratingCurrentUserReactions = false;
    if (didMutate) {
      _emitLoaded();
    }
    if (_pendingHydrationPass) {
      _pendingHydrationPass = false;
      await hydrateCurrentUserReactions(currentUserId: normalizedUserId);
    }
  }

  Future<Comment?> getCommentById(String commentId) async {
    final result = await getCommentUseCase(commentId);
    return result.fold(
      (failure) {
        emit(
          CommentActionError(
            _resolveErrorMessage(failure.message, fallbackKey: "load_failed"),
          ),
        );
        return null;
      },
      (comment) {
        return comment;
      },
    );
  }

  Future<bool> getRepliesForComment(
    String parentCommentId, {
    String? postId,
    int? page,
    int? limit,
    String? sort,
    String? fields,
    String? keyword,
    bool emitState = true,
  }) async {
    var isSuccess = false;

    final result = await getRepliesUseCase(
      parentCommentId,
      page: page,
      limit: limit,
      sort: sort,
      fields: fields,
      keyword: keyword,
    );

    result.fold(
      (failure) {
        emit(
          CommentActionError(
            _resolveErrorMessage(failure.message, fallbackKey: "load_failed"),
          ),
        );
        isSuccess = false;
      },
      (replies) {
        final normalizedReplies = replies
            .map((reply) => _forceParentId(reply, parentCommentId))
            .toList();

        final existingReplyIdsForParent = _allComments
            .where((c) => c.parentCommentId == parentCommentId)
            .map((c) => c.id)
            .toSet();
        final replyIds = normalizedReplies.map((r) => r.id).toSet();

        _allComments.removeWhere(
          (c) =>
              replyIds.contains(c.id) || (c.parentCommentId == parentCommentId),
        );

        _allComments.addAll(normalizedReplies);
        final idsToRefreshHydration = <String>{
          ...existingReplyIdsForParent,
          ...replyIds,
        };
        for (final id in idsToRefreshHydration) {
          _hydratedCurrentUserReactionCommentIds.remove(id);
          _reactionIdsByComment.remove(id);
        }
        isSuccess = true;
      },
    );

    if (emitState) {
      _emitLoaded();
    }
    return isSuccess;
  }

  List<Comment> _getStructuredComments() {
    final roots = _allComments.where((c) => c.parentCommentId == null).toList();

    return roots.map((root) {
      final replies = _allComments
          .where((c) => c.parentCommentId == root.id)
          .toList();

      return root.copyWith(
        repliesList: replies,
        repliesCount: replies.length > root.repliesCount
            ? replies.length
            : root.repliesCount,
      );
    }).toList();
  }

  Future<void> toggleRepliesVisibility({
    required String parentCommentId,
    required String postId,
    required String currentUserId,
  }) async {
    if (_loadingReplyParentIds.contains(parentCommentId)) {
      return;
    }

    if (_expandedReplyParentIds.contains(parentCommentId)) {
      _expandedReplyParentIds.remove(parentCommentId);
      _emitLoaded();
      return;
    }

    _loadingReplyParentIds.add(parentCommentId);
    _emitLoaded();

    final hadExistingReplies = _allComments.any(
      (c) => c.parentCommentId == parentCommentId,
    );
    final isSuccess = await getRepliesForComment(
      parentCommentId,
      postId: postId,
      page: 1,
      limit: 50,
      emitState: false,
    );

    _loadingReplyParentIds.remove(parentCommentId);
    final hasRepliesNow = _allComments.any(
      (c) => c.parentCommentId == parentCommentId,
    );
    if (isSuccess || hadExistingReplies || hasRepliesNow) {
      _expandedReplyParentIds.add(parentCommentId);
    }
    await hydrateCurrentUserReactions(currentUserId: currentUserId);
    _emitLoaded();
  }

  Future<void> addOrUpdateComment(String postId, String text) async {
    if (text.trim().isEmpty) return;

    if (_editingComment != null) {
      await _submitEditComment(text);
    } else {
      await _submitNewComment(postId, text);
    }
  }

  Future<void> _submitNewComment(String postId, String text) async {
    final previousComments = List<Comment>.from(_allComments);
    final result = await addCommentUseCase(
      postId: postId,
      text: text,
      parentCommentId: _replyingTo?.id,
    );

    result.fold(
      (failure) {
        _allComments = previousComments;
        emit(
          CommentActionError(
            _resolveErrorMessage(failure.message, fallbackKey: "add_failed"),
          ),
        );
        _emitLoaded();
      },
      (newComment) {
        final normalizedComment = _replyingTo != null
            ? _attachParentIdIfMissing(newComment, _replyingTo!.id)
            : newComment;

        _upsertComment(normalizedComment);

        if (normalizedComment.parentCommentId != null) {
          _expandedReplyParentIds.add(normalizedComment.parentCommentId!);
          final parentIndex = _allComments.indexWhere(
            (c) => c.id == normalizedComment.parentCommentId,
          );
          if (parentIndex != -1) {
            final parent = _allComments[parentIndex];
            _allComments[parentIndex] = Comment(
              id: parent.id,
              postId: parent.postId,
              authorId: parent.authorId,
              authorName: parent.authorName,
              authorImage: parent.authorImage,
              text: parent.text,
              createdAt: parent.createdAt,
              editedAt: parent.editedAt,
              isEdited: parent.isEdited,
              reactions: parent.reactions,
              reactionsCount: parent.reactionsCount,
              userReaction: parent.userReaction,
              repliesCount: parent.repliesCount + 1,
              parentCommentId: parent.parentCommentId,
              repliesList: parent.repliesList,
              history: parent.history,
            );
          }
        }

        _replyingTo = null;
        _editingComment = null;
        _emitLoaded();
        emit(const CommentActionSuccess("added", commentsDelta: 1));
      },
    );
  }

  Future<void> _submitEditComment(String newText) async {
    if (_editingComment == null) {
      return;
    }

    final previousComments = List<Comment>.from(_allComments);

    final result = await editCommentUseCase(
      commentId: _editingComment!.id,
      newContent: newText,
    );

    result.fold(
      (failure) {
        _allComments = previousComments;
        emit(
          CommentActionError(
            _resolveErrorMessage(failure.message, fallbackKey: "update_failed"),
          ),
        );
        _emitLoaded();
      },
      (updatedComment) {
        final index = _allComments.indexWhere((c) => c.id == updatedComment.id);
        if (index != -1) {
          final oldComment = _allComments[index];
          final revision = CommentRevision(
            text: oldComment.text,
            editTime: oldComment.editedAt ?? oldComment.createdAt,
          );

          final updatedHistory = List<CommentRevision>.from(
            oldComment.history ?? [],
          )..add(revision);

          _allComments[index] = Comment(
            id: updatedComment.id,
            postId: updatedComment.postId,
            authorId: updatedComment.authorId,
            authorName: updatedComment.authorName,
            authorImage: updatedComment.authorImage,
            text: updatedComment.text,
            createdAt: updatedComment.createdAt,
            editedAt: updatedComment.editedAt ?? DateTime.now(),
            isEdited:
                updatedComment.isEdited || updatedComment.editedAt != null,
            reactions: updatedComment.reactions,
            reactionsCount: updatedComment.reactionsCount,
            userReaction: updatedComment.userReaction,
            repliesCount: updatedComment.repliesCount,
            parentCommentId: updatedComment.parentCommentId,
            history: updatedHistory,
          );
        }

        _editingComment = null;
        _emitLoaded();
        emit(const CommentActionSuccess("updated"));
      },
    );
  }

  Future<void> deleteComment(String commentId) async {
    final previousComments = List<Comment>.from(_allComments);
    final deletedComment = _allComments.cast<Comment?>().firstWhere(
      (c) => c?.id == commentId,
      orElse: () => null,
    );
    final parentCommentId = deletedComment?.parentCommentId;
    final removedReplyIds = _allComments
        .where((c) => c.parentCommentId == commentId)
        .map((c) => c.id)
        .toSet();
    final removedCommentIds = <String>{commentId, ...removedReplyIds};
    final removedCommentsCount = removedCommentIds.length;
    final result = await deleteCommentUseCase(commentId);

    result.fold(
      (failure) {
        _allComments = previousComments;
        emit(
          CommentActionError(
            _resolveErrorMessage(failure.message, fallbackKey: "delete_failed"),
          ),
        );
        _emitLoaded();
      },
      (_) {
        _allComments.removeWhere((c) => c.id == commentId);
        _allComments.removeWhere((c) => c.parentCommentId == commentId);
        _reactionIdsByComment.remove(commentId);
        for (final removedReplyId in removedReplyIds) {
          _reactionIdsByComment.remove(removedReplyId);
        }

        if (parentCommentId != null && parentCommentId.trim().isNotEmpty) {
          final parentIndex = _allComments.indexWhere(
            (c) => c.id == parentCommentId,
          );
          if (parentIndex != -1) {
            final parent = _allComments[parentIndex];
            _allComments[parentIndex] = parent.copyWith(
              repliesCount: (parent.repliesCount - 1).clamp(0, 1 << 31).toInt(),
            );
          }
        }

        if (_replyingTo != null &&
            removedCommentIds.contains(_replyingTo!.id)) {
          _replyingTo = null;
        }
        if (_editingComment != null &&
            removedCommentIds.contains(_editingComment!.id)) {
          _editingComment = null;
        }

        _expandedReplyParentIds.remove(commentId);
        _loadingReplyParentIds.remove(commentId);
        _emitLoaded();
        emit(
          CommentActionSuccess("deleted", commentsDelta: -removedCommentsCount),
        );
      },
    );
  }

  Future<void> hideComment(String commentId) async {
    final previousComments = List<Comment>.from(_allComments);
    try {
      _allComments.removeWhere((c) => c.id == commentId);
      _expandedReplyParentIds.remove(commentId);
      _loadingReplyParentIds.remove(commentId);
      _emitLoaded();
      emit(const CommentActionSuccess("hidden"));
    } catch (e) {
      _allComments = previousComments;
      _emitLoaded();
    }
  }

  Future<void> reportComment(String commentId) async {
    try {
      emit(const CommentActionSuccess("reported"));
      _emitLoaded();
    } catch (e) {
      emit(const CommentActionError("report_failed"));
    }
  }

  void triggerReply(Comment comment) {
    _replyingTo = comment;
    _editingComment = null;
    _emitLoaded();
  }

  void triggerEdit(Comment comment) {
    _editingComment = comment;
    _replyingTo = null;
    emit(CommentEditState(comment));
  }

  void cancelReplyOrEdit() {
    _replyingTo = null;
    _editingComment = null;
    _emitLoaded();
  }

  String _resolveErrorMessage(String message, {required String fallbackKey}) {
    if (message.trim().isEmpty || message == "unexpected_error") {
      return fallbackKey;
    }
    return message;
  }

  Comment _attachParentIdIfMissing(Comment comment, String parentCommentId) {
    final existingParentId = comment.parentCommentId?.trim();
    final hasValidParentId =
        existingParentId != null &&
        existingParentId.isNotEmpty &&
        Validator.isValidId(existingParentId) &&
        existingParentId.toLowerCase() != 'null' &&
        existingParentId.toLowerCase() != 'undefined';
    if (hasValidParentId) {
      return comment;
    }
    return Comment(
      id: comment.id,
      postId: comment.postId,
      authorId: comment.authorId,
      authorName: comment.authorName,
      authorImage: comment.authorImage,
      text: comment.text,
      createdAt: comment.createdAt,
      editedAt: comment.editedAt,
      isEdited: comment.isEdited,
      reactions: comment.reactions,
      reactionsCount: comment.reactionsCount,
      userReaction: comment.userReaction,
      repliesCount: comment.repliesCount,
      parentCommentId: parentCommentId,
      repliesList: comment.repliesList,
      history: comment.history,
    );
  }

  Comment _forceParentId(Comment comment, String parentCommentId) {
    final existingParentId = comment.parentCommentId?.trim();
    if (existingParentId == parentCommentId) {
      return comment;
    }
    return Comment(
      id: comment.id,
      postId: comment.postId,
      authorId: comment.authorId,
      authorName: comment.authorName,
      authorImage: comment.authorImage,
      text: comment.text,
      createdAt: comment.createdAt,
      editedAt: comment.editedAt,
      isEdited: comment.isEdited,
      reactions: comment.reactions,
      reactionsCount: comment.reactionsCount,
      userReaction: comment.userReaction,
      repliesCount: comment.repliesCount,
      parentCommentId: parentCommentId,
      repliesList: comment.repliesList,
      history: comment.history,
    );
  }

  void _upsertComment(Comment comment) {
    final existingIndex = _allComments.indexWhere((c) => c.id == comment.id);
    if (existingIndex == -1) {
      _allComments.add(comment);
      return;
    }
    _allComments[existingIndex] = comment;
  }

  void _emitLoaded() {
    emit(
      CommentLoaded(
        _getStructuredComments(),
        replyingToComment: _replyingTo,
        expandedReplyParentIds: Set<String>.from(_expandedReplyParentIds),
        loadingReplyParentIds: Set<String>.from(_loadingReplyParentIds),
      ),
    );
  }

  Future<void> toggleReactionOnComment({
    required String commentId,
    required String currentUserId,
    required ReactionType currentReaction,
  }) async {
    final currentReactionId = _resolveReactionIdForComment(
      commentId: commentId,
      currentUserId: currentUserId,
    );
    final nextReaction = currentReaction == ReactionType.none
        ? ReactionType.like
        : ReactionType.none;

    final previousComment = _applyCommentReactionOptimistically(
      commentId: commentId,
      currentUserId: currentUserId,
      reactionType: nextReaction,
      currentReactionId: currentReactionId,
    );
    if (previousComment == null) {
      return;
    }

    if (nextReaction == ReactionType.none) {
      final result = await removeReactionFromCommentUseCase(
        commentId: commentId,
        reactionId: currentReactionId,
      );
      result.fold((failure) {
        _restoreComment(previousComment);
        emit(
          CommentActionError(
            _resolveErrorMessage(failure.message, fallbackKey: "update_failed"),
          ),
        );
        _emitLoaded();
      }, (_) {
        _reactionIdsByComment.remove(commentId);
      });
      return;
    }

    final result = await reactToCommentUseCase(
      commentId: commentId,
      reactionType: nextReaction.name,
      isUpdate: currentReaction != ReactionType.none,
      reactionId: currentReactionId,
    );
    result.fold((failure) {
      _restoreComment(previousComment);
      emit(
        CommentActionError(
          _resolveErrorMessage(failure.message, fallbackKey: "update_failed"),
        ),
      );
      _emitLoaded();
    }, (updatedReactionId) {
      final resolvedReactionId =
          _normalizeReactionIdForApi(updatedReactionId) ??
          _normalizeReactionIdForApi(currentReactionId);
      if (resolvedReactionId != null) {
        _reactionIdsByComment[commentId] = resolvedReactionId;
      }
    });
  }

  Future<void> chooseReactionOnComment({
    required String commentId,
    required String currentUserId,
    required ReactionType chosenReaction,
    required ReactionType currentReaction,
  }) async {
    if (chosenReaction == ReactionType.none ||
        chosenReaction == currentReaction) {
      return;
    }

    final currentReactionId = _resolveReactionIdForComment(
      commentId: commentId,
      currentUserId: currentUserId,
    );
    final previousComment = _applyCommentReactionOptimistically(
      commentId: commentId,
      currentUserId: currentUserId,
      reactionType: chosenReaction,
      currentReactionId: currentReactionId,
    );
    if (previousComment == null) {
      return;
    }

    final result = await reactToCommentUseCase(
      commentId: commentId,
      reactionType: chosenReaction.name,
      isUpdate: currentReaction != ReactionType.none,
      reactionId: currentReactionId,
    );
    result.fold((failure) {
      _restoreComment(previousComment);
      emit(
        CommentActionError(
          _resolveErrorMessage(failure.message, fallbackKey: "update_failed"),
        ),
      );
      _emitLoaded();
    }, (updatedReactionId) {
      final resolvedReactionId =
          _normalizeReactionIdForApi(updatedReactionId) ??
          _normalizeReactionIdForApi(currentReactionId);
      if (resolvedReactionId != null) {
        _reactionIdsByComment[commentId] = resolvedReactionId;
      }
    });
  }

  Comment? _applyCommentReactionOptimistically({
    required String commentId,
    required String currentUserId,
    required ReactionType reactionType,
    String? currentReactionId,
  }) {
    final index = _allComments.indexWhere((c) => c.id == commentId);
    if (index == -1) {
      return null;
    }

    final previous = _allComments[index];
    final filtered = previous.reactions
        .where((reaction) => reaction.userId != currentUserId)
        .toList();

    if (reactionType != ReactionType.none) {
      final optimisticReactionId =
          _normalizeReactionIdForApi(currentReactionId) ??
          'local-$commentId-$currentUserId';
      filtered.add(
        Reaction(
          id: optimisticReactionId,
          userId: currentUserId,
          postId: previous.postId,
          type: reactionType,
        ),
      );
    }

    final nextCount = reactionType == ReactionType.none
        ? (previous.reactionsCount - 1).clamp(0, 1 << 30).toInt()
        : (previous.userReaction == ReactionType.none
              ? previous.reactionsCount + 1
              : previous.reactionsCount);
    final updatedCounts = Map<ReactionType, int>.from(
      previous.reactionCountsByType,
    );
    if (previous.userReaction != ReactionType.none) {
      final oldCount = (updatedCounts[previous.userReaction] ?? 0) - 1;
      if (oldCount <= 0) {
        updatedCounts.remove(previous.userReaction);
      } else {
        updatedCounts[previous.userReaction] = oldCount;
      }
    }
    if (reactionType != ReactionType.none) {
      updatedCounts[reactionType] = (updatedCounts[reactionType] ?? 0) + 1;
    }

    _allComments[index] = previous.copyWith(
      reactions: filtered,
      reactionsCount: nextCount,
      userReaction: reactionType,
      reactionCountsByType: updatedCounts,
    );

    _emitLoaded();
    return previous;
  }

  void _restoreComment(Comment previousComment) {
    final index = _allComments.indexWhere((c) => c.id == previousComment.id);
    if (index == -1) {
      return;
    }
    _allComments[index] = previousComment;
  }

  String? _normalizeReactionIdForApi(String? reactionId) {
    final trimmed = reactionId?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    if (trimmed.startsWith('local-')) {
      return null;
    }
    if (!Validator.isValidId(trimmed)) {
      return null;
    }
    return trimmed;
  }

  String? _resolveReactionIdForComment({
    required String commentId,
    required String currentUserId,
  }) {
    final cached = _normalizeReactionIdForApi(_reactionIdsByComment[commentId]);
    if (cached != null) {
      return cached;
    }

    final comment = _allComments.cast<Comment?>().firstWhere(
      (c) => c?.id == commentId,
      orElse: () => null,
    );
    if (comment == null) {
      return null;
    }

    final reaction = comment.reactions.reversed.cast<Reaction?>().firstWhere(
      (item) => item?.userId == currentUserId,
      orElse: () => null,
    );
    if (reaction == null) {
      return null;
    }

    final normalized = _normalizeReactionIdForApi(reaction.id);
    if (normalized == null) {
      return null;
    }
    _reactionIdsByComment[commentId] = normalized;
    return normalized;
  }

  bool _hasCurrentUserReactionId(Comment comment, String currentUserId) {
    for (final reaction in comment.reactions.reversed) {
      if (reaction.userId != currentUserId) {
        continue;
      }
      final normalized = _normalizeReactionIdForApi(reaction.id);
      if (normalized != null) {
        return true;
      }
    }
    return false;
  }
}
