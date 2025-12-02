import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/entities/comment_history.dart';
import 'package:auth/domain/usecases/comment/add_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/edit_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/get_comments_usecase.dart';
import 'package:auth/domain/usecases/comment/get_replies_usecase.dart';
import 'package:auth/domain/usecases/comment/mention_users_in_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/react_to_comment_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final GetCommentsUseCase getCommentsUseCase;
  final AddCommentUseCase addCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;
  final EditCommentUseCase editCommentUseCase;
  final GetRepliesUseCase getRepliesUseCase;
  final MentionUsersInCommentUseCase mentionUsersInCommentUseCase;
  final ReactToCommentUseCase reactToCommentUseCase;

  CommentCubit({
    required this.getCommentsUseCase,
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

  Comment? get replyingTo => _replyingTo;
  Comment? get editingComment => _editingComment;

  Future<void> getComments(String postId) async {
    final dummyData = _generateDummyData(postId);
    emit(CommentLoading(dummyData));

    await Future.delayed(const Duration(seconds: 2));

    try {
      if (_allComments.isEmpty) {
        _allComments = dummyData;
      }
      emit(CommentLoaded(_getStructuredComments()));
    } catch (e) {
      emit(const CommentError("Failed to load comments"));
    }
  }

  Future<void> addOrUpdateComment(String postId, String text) async {
    if (text.trim().isEmpty) return;

    if (_editingComment != null) {
      await _submitEditComment(postId, text);
    } else {
      await _submitNewComment(postId, text);
    }
  }

  Future<void> _submitNewComment(String postId, String text) async {
    final previousComments = List<Comment>.from(_allComments);
    try {
      final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: postId,
        authorId: "curr_user",
        authorName: "My Profile",
        authorImage: "",
        text: text,
        createdAt: DateTime.now(),
        parentCommentId: _replyingTo?.id,
        reactions: const [],
      );

      _allComments.add(newComment);
      cancelReplyOrEdit();
      emit(CommentLoaded(_getStructuredComments(), replyingToComment: null));
    } catch (e) {
      emit(const CommentActionError("Failed to add comment"));
      emit(CommentLoaded(previousComments));
    }
  }

  void prepareForEditSubmission(Comment comment) {
    _editingComment = comment;
    _replyingTo = null;
  }

  Future<void> _submitEditComment(String postId, String newText) async {
    final previousComments = List<Comment>.from(_allComments);
    try {
      final index = _allComments.indexWhere((c) => c.id == _editingComment!.id);

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
          id: oldComment.id,
          postId: postId,
          authorId: oldComment.authorId,
          authorName: oldComment.authorName,
          text: newText,
          createdAt: oldComment.createdAt,
          editedAt: DateTime.now(),
          history: updatedHistory,
        );
      }

      _editingComment = null;
      emit(CommentLoaded(List.from(_allComments)));
      emit(const CommentActionSuccess("Comment updated successfully"));
    } catch (e) {
      emit(const CommentActionError("Failed to edit comment"));
      emit(CommentLoaded(previousComments));
    }
  }

  Future<void> deleteComment(String commentId) async {
    final previousComments = List<Comment>.from(_allComments);

    try {
      _allComments.removeWhere((c) => c.id == commentId);
      _allComments.removeWhere((c) => c.parentCommentId == commentId);

      emit(CommentLoaded(List.from(_allComments)));
      emit(const CommentActionSuccess("Comment deleted"));
    } catch (e) {
      emit(const CommentActionError("Failed to delete"));
      emit(CommentLoaded(previousComments));
    }
  }

  Future<void> hideComment(String commentId) async {
    final previousComments = List<Comment>.from(_allComments);
    try {
      _allComments.removeWhere((c) => c.id == commentId);
      emit(CommentLoaded(List.from(_allComments)));
      emit(const CommentActionSuccess("Comment hidden"));
    } catch (e) {
      emit(CommentLoaded(previousComments));
    }
  }

  Future<void> reportComment(String commentId) async {
    try {
      emit(const CommentActionSuccess("Comment reported"));
      emit(CommentLoaded(List.from(_allComments)));
    } catch (e) {
      emit(const CommentActionError("Failed to report"));
    }
  }

  void triggerReply(Comment comment) {
    _replyingTo = comment;
    _editingComment = null;
    emit(
      CommentLoaded(_getStructuredComments(), replyingToComment: _replyingTo),
    );
  }

  void triggerEdit(Comment comment) {
    _editingComment = comment;
    _replyingTo = null;
    emit(CommentEditState(comment));
  }

  void cancelReplyOrEdit() {
    _replyingTo = null;
    _editingComment = null;
    emit(CommentLoaded(_getStructuredComments(), replyingToComment: null));
  }

  List<Comment> _generateDummyData(String postId) {
    return List.generate(10, (index) {
      return Comment(
        id: "$index",
        postId: postId,
        authorId: "user$index",
        authorName: " User Name${index + 1}",
        authorImage: "",
        text:
            "This is a dummy comment text to simulate the loading skeleton effect on the screen lines.",
        createdAt: DateTime.now().subtract(Duration(minutes: index * 5)),
        reactions: const [],
      );
    });
  }

  List<Comment> _getStructuredComments() {
    var rootComments = _allComments
        .where((c) => c.parentCommentId == null)
        .toList();

    List<Comment> structuredList = rootComments.map((root) {
      var replies = _allComments
          .where((c) => c.parentCommentId == root.id)
          .toList();
      return Comment(
        id: root.id,
        postId: root.postId,
        authorId: root.authorId,
        authorName: root.authorName,
        authorImage: root.authorImage,
        text: root.text,
        createdAt: root.createdAt,
        parentCommentId: root.parentCommentId,
        reactions: root.reactions,
        repliesList: replies,
        history: root.history,
        editedAt: root.editedAt,
      );
    }).toList();

    return structuredList;
  }
}
