import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/reaction_type.dart';
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

    result.fold(
      (failure) => emit(
        CommentError(
          _resolveErrorMessage(failure.message, fallbackKey: "load_failed"),
        ),
      ),
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
          _upsertComment(reply);
        }
      });
    }
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

    if (previousComment == null) return;

    final result = await reactToCommentUseCase(
      commentId: commentId,
      reactionType: chosenReaction.name,
      isUpdate: currentReaction != ReactionType.none,
      reactionId: currentReactionId,
    );

    result.fold(
      (failure) {
        _restoreComment(previousComment);
        emit(
          CommentActionError(
            _resolveErrorMessage(failure.message, fallbackKey: "update_failed"),
          ),
        );
        _emitLoaded();
      },
      (updatedReactionId) {
        final resolvedId =
            updatedReactionId ??
            currentReactionId;
        if (resolvedId != null) {
          _reactionIdsByComment[commentId] = resolvedId;
        }
      },
    );
  }
  Future<void> hideComment(String commentId) async {
    final previousComments = List<Comment>.from(_allComments);
    try {
      _allComments.removeWhere((c) => c.id == commentId || c.parentCommentId == commentId);
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
      emit(CommentActionError(_resolveErrorMessage(e.toString(), fallbackKey: "report_failed")));
    }
  }

  Future<bool> getRepliesForComment(
    String parentCommentId, {
    int? page,
    int? limit,
    String? sort,
    String? fields,
    String? keyword,
    bool emitState = true,
  }) async {
    final result = await getRepliesUseCase(
      parentCommentId,
      page: page,
      limit: limit,
      sort: sort,
      fields: fields,
      keyword: keyword,
    );

    return result.fold(
      (failure) {
        emit(
          CommentActionError(
            _resolveErrorMessage(failure.message, fallbackKey: "load_failed"),
          ),
        );
        return false;
      },
      (replies) {
        final replyIds = replies.map((r) => r.id).toSet();
        _allComments.removeWhere(
          (c) =>
              replyIds.contains(c.id) || (c.parentCommentId == parentCommentId),
        );
        _allComments.addAll(replies);

        final idsToRefresh = {...replyIds, parentCommentId};
        for (final id in idsToRefresh) {
          _hydratedCurrentUserReactionCommentIds.remove(id);
          _reactionIdsByComment.remove(id);
        }
        if (emitState) _emitLoaded();
        return true;
      },
    );
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
        _upsertComment(newComment);
        if (newComment.parentCommentId != null) {
          _expandedReplyParentIds.add(newComment.parentCommentId!);
          final parentIdx = _allComments.indexWhere(
            (c) => c.id == newComment.parentCommentId,
          );
          if (parentIdx != -1) {
            _allComments[parentIdx] = _allComments[parentIdx].copyWith(
              repliesCount: _allComments[parentIdx].repliesCount + 1,
            );
          }
        }
        _replyingTo = null;
        _emitLoaded();
        emit(const CommentActionSuccess("added", commentsDelta: 1));
      },
    );
  }

  Future<void> _submitEditComment(String newText) async {
    if (_editingComment == null) return;
    final result = await editCommentUseCase(
      commentId: _editingComment!.id,
      newContent: newText,
    );

    result.fold(
      (failure) => emit(
        CommentActionError(
          _resolveErrorMessage(failure.message, fallbackKey: "update_failed"),
        ),
      ),
      (updatedComment) {
        _upsertComment(updatedComment);
        _editingComment = null;
        _emitLoaded();
        emit(const CommentActionSuccess("updated"));
      },
    );
  }

  Future<void> deleteComment(String commentId) async {
    final previousComments = List<Comment>.from(_allComments);
    final commentToDelete = _allComments.cast<Comment?>().firstWhere(
      (c) => c?.id == commentId,
      orElse: () => null,
    );
    final parentId = commentToDelete?.parentCommentId;

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
        _allComments.removeWhere(
          (c) => c.id == commentId || c.parentCommentId == commentId,
        );
        if (parentId != null) {
          final parentIdx = _allComments.indexWhere((c) => c.id == parentId);
          if (parentIdx != -1) {
            _allComments[parentIdx] = _allComments[parentIdx].copyWith(
              repliesCount: (_allComments[parentIdx].repliesCount - 1).clamp(
                0,
                999,
              ),
            );
          }
        }
        _expandedReplyParentIds.remove(commentId);
        _loadingReplyParentIds.remove(commentId);
        _emitLoaded();
        emit(const CommentActionSuccess("deleted", commentsDelta: -1));
      },
    );
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
    if (_loadingReplyParentIds.contains(parentCommentId)) return;

    if (_expandedReplyParentIds.contains(parentCommentId)) {
      _expandedReplyParentIds.remove(parentCommentId);
      _emitLoaded();
      return;
    }

    _loadingReplyParentIds.add(parentCommentId);
    _emitLoaded();

    final isSuccess = await getRepliesForComment(
      parentCommentId,
      emitState: false,
    );

    _loadingReplyParentIds.remove(parentCommentId);
    if (isSuccess ||
        _allComments.any((c) => c.parentCommentId == parentCommentId)) {
      _expandedReplyParentIds.add(parentCommentId);
    }
    await hydrateCurrentUserReactions(currentUserId: currentUserId);
    _emitLoaded();
  }

  void _upsertComment(Comment comment) {
    final index = _allComments.indexWhere((c) => c.id == comment.id);
    if (index == -1) {
      _allComments.add(comment);
    } else {
      _allComments[index] = comment;
    }
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

  // --- REACTION LOGIC ---

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
    if (previousComment == null) return;

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
      }, (_) => _reactionIdsByComment.remove(commentId));
    } else {
      final result = await reactToCommentUseCase(
        commentId: commentId,
        reactionType: nextReaction.name,
        isUpdate: currentReaction != ReactionType.none,
        reactionId: currentReactionId,
      );
      result.fold(
        (failure) {
          _restoreComment(previousComment);
          emit(
            CommentActionError(
              _resolveErrorMessage(
                failure.message,
                fallbackKey: "update_failed",
              ),
            ),
          );
          _emitLoaded();
        },
        (updatedId) {
          final resolvedId =
              updatedId??
              currentReactionId;
          if (resolvedId != null) _reactionIdsByComment[commentId] = resolvedId;
        },
      );
    }
  }

  Future<void> hydrateCurrentUserReactions({
    required String currentUserId,
  }) async {
    if (currentUserId.trim().isEmpty || _isHydratingCurrentUserReactions) {
      return;
    }

    final candidates = _allComments.where((c) {
      if (c.id.isEmpty || _hydratedCurrentUserReactionCommentIds.contains(c.id)) {
        return false;
      }
      return c.userReaction == ReactionType.none ||
          !_hasCurrentUserReactionId(c, currentUserId);
    }).toList();

    if (candidates.isEmpty) return;

    _isHydratingCurrentUserReactions = true;
    bool didMutate = false;

    for (final comment in candidates) {
      final result = await getCommentReactionsUseCase(commentId: comment.id);
      if (isClosed) return;

      result.fold((_) {}, (reactions) {
        _hydratedCurrentUserReactionCommentIds.add(comment.id);
        final mine = reactions.cast<Reaction?>().firstWhere(
          (r) => r?.userId == currentUserId,
          orElse: () => null,
        );

        if (mine != null) {
          final index = _allComments.indexWhere(
            (item) => item.id == comment.id,
          );
          if (index != -1) {
            _allComments[index] = _allComments[index].copyWith(
              userReaction: mine.type,
              reactions: [
                ..._allComments[index].reactions.where(
                  (r) => r.userId != currentUserId,
                ),
                mine,
              ],
            );
            final normId = mine.id;
             _reactionIdsByComment[comment.id] = normId;
            didMutate = true;
          }
        }
      });
    }

    _isHydratingCurrentUserReactions = false;
    if (didMutate) _emitLoaded();
  }

  // --- UTILITIES ---

  Comment? _applyCommentReactionOptimistically({
    required String commentId,
    required String currentUserId,
    required ReactionType reactionType,
    String? currentReactionId,
  }) {
    final index = _allComments.indexWhere((c) => c.id == commentId);
    if (index == -1) return null;

    final previous = _allComments[index];
    final filtered = previous.reactions
        .where((r) => r.userId != currentUserId)
        .toList();

    if (reactionType != ReactionType.none) {
      filtered.add(
        Reaction(
          id: currentReactionId!,
          userId: currentUserId,
          postId: previous.postId,
          type: reactionType,
        ),
      );
    }

    _allComments[index] = previous.copyWith(
      reactions: filtered,
      reactionsCount: reactionType == ReactionType.none
          ? (previous.reactionsCount - 1).clamp(0, 999)
          : (previous.userReaction == ReactionType.none
                ? previous.reactionsCount + 1
                : previous.reactionsCount),
      userReaction: reactionType,
    );

    _emitLoaded();
    return previous;
  }

  void _restoreComment(Comment previous) {
    final idx = _allComments.indexWhere((c) => c.id == previous.id);
    if (idx != -1) {
      _allComments[idx] = previous;
      _emitLoaded();
    }
  }



  String? _resolveReactionIdForComment({
    required String commentId,
    required String currentUserId,
  }) {
    final cached = _reactionIdsByComment[commentId];
    if (cached != null) return cached;

    final comment = _allComments.cast<Comment?>().firstWhere(
      (c) => c?.id == commentId,
      orElse: () => null,
    );
    final reaction = comment?.reactions.firstWhere(
      (r) => r.userId == currentUserId,
      orElse: () =>
          Reaction(id: '', userId: '', postId: '', type: ReactionType.none),
    );

    final normId = reaction?.id;
    if (normId != null) _reactionIdsByComment[commentId] = normId;
    return normId;
  }

  bool _hasCurrentUserReactionId(Comment comment, String userId) =>
      comment.reactions.any(
        (r) => r.userId == userId && r.id.isNotEmpty,
      );

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

  String _resolveErrorMessage(String message, {required String fallbackKey}) =>
      (message.isEmpty || message == "unexpected_error")
      ? fallbackKey
      : message;
}
