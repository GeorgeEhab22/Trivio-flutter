import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/entities/comment_history.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/usecases/comment/add_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/edit_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/get_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/get_comments_usecase.dart';
import 'package:auth/domain/usecases/comment/get_replies_usecase.dart';
import 'package:auth/domain/usecases/comment/mention_users_in_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/react_to_comment_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final GetCommentsUseCase getCommentsUseCase;
  final GetCommentUseCase getCommentUseCase;
  final AddCommentUseCase addCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;
  final EditCommentUseCase editCommentUseCase;
  final GetRepliesUseCase getRepliesUseCase;
  final MentionUsersInCommentUseCase mentionUsersInCommentUseCase;
  final ReactToCommentUseCase reactToCommentUseCase;

  CommentCubit({
    required this.getCommentsUseCase,
    required this.getCommentUseCase,
    required this.addCommentUseCase,
    required this.deleteCommentUseCase,
    required this.editCommentUseCase,
    required this.getRepliesUseCase,
    required this.mentionUsersInCommentUseCase,
    required this.reactToCommentUseCase,
  }) : super(CommentInitial());

  List<Comment> _allComments = [];
  Comment? _replyingTo;
  Comment? _editingComment;
  final Set<String> _expandedReplyParentIds = {};
  final Set<String> _loadingReplyParentIds = {};

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

        final replyIds = normalizedReplies.map((r) => r.id).toSet();

        // Remove old local copies to prevent duplicates
        _allComments.removeWhere(
          (c) =>
              replyIds.contains(c.id) || (c.parentCommentId == parentCommentId),
        );

        _allComments.addAll(normalizedReplies);
        isSuccess = true;
      },
    );

    if (emitState) {
      _emitLoaded(); // This triggers the build of the nested tree
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
        emit(const CommentActionSuccess("added"));
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
            isEdited: updatedComment.isEdited || updatedComment.editedAt != null,
            reactions: updatedComment.reactions,
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
        _expandedReplyParentIds.remove(commentId);
        _loadingReplyParentIds.remove(commentId);
        _emitLoaded();
        emit(const CommentActionSuccess("deleted"));
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

  // --- UI Triggers ---

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

  // --- Helpers ---

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
}
