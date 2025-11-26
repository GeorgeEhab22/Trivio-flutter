import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/home/comments/widgets/comment_item.dart';
import 'package:flutter/material.dart';
import 'widgets/comments_header.dart';
import 'widgets/comments_list.dart';
import 'widgets/comments_input_field.dart';

class CommentsBottomSheet extends StatefulWidget {
  final VoidCallback onCommentAdded;
  final VoidCallback onCommentDeleted;
  final int reactionsCount;

  final String currentUserId = "1";

  const CommentsBottomSheet({
    super.key,
    required this.onCommentAdded,
    required this.onCommentDeleted,
    required this.reactionsCount,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late List<Map<String, dynamic>> _comments;
  String? _replyToId;
  String? _replyToUser;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  final int _limit = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _comments = [];

    _scrollController.addListener(_onScroll);

    _loadMore();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _loadMore();
    }
  }

  //TODO: all of these methods should connect to backend via Block
  void _addComment(String text) {
    if (text.trim().isEmpty) return;

    final normalized = text.trim();
    if (_replyToId != null) {
      final parentIndex = _comments.indexWhere((c) => c["id"] == _replyToId);
      if (parentIndex != -1) {
        setState(() {
          _comments[parentIndex]["replies"].insert(0, {
            "id": UniqueKey().toString(),
            "user": "You",
            "text": normalized,
            "time": DateTime.now(),
            "replies": <Map<String, dynamic>>[],
          });
          _replyToId = null;
          _replyToUser = null;
        });
      } else {
        _insertTopLevelComment(normalized);
        _replyToId = null;
        _replyToUser = null;
      }
    } else {
      _insertTopLevelComment(normalized);
    }

    _controller.clear();
    widget.onCommentAdded();
  }

  void _insertTopLevelComment(String text) {
    final newComment = {
      "id": UniqueKey().toString(),
      "user": "You",
      "text": text,
      "time": DateTime.now(),
      "replies": <Map<String, dynamic>>[],
    };

    setState(() {
      _comments.insert(0, newComment);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _listKey.currentState?.insertItem(0);
    });
  }

  void _reportComment(String id) {}

  void _hideComment(String id) {}

  void _startReply(String id, String username) {
    setState(() {
      _replyToId = id;
      _replyToUser = username;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _cancelReply() {
    setState(() {
      _replyToId = null;
      _replyToUser = null;
    });
  }

  void _editComment(String id, String newText) {
    for (var c in _comments) {
      if (c["id"] == id) {
        setState(() => c["text"] = newText);
        return;
      }
      for (var r in c["replies"]) {
        if (r["id"] == id) {
          setState(() => r["text"] = newText);
          return;
        }
      }
    }
  }

  void _deleteComment(String id) {
    // Try to remove top-level comment with animation first
    final topIndex = _comments.indexWhere((c) => c["id"] == id);
    if (topIndex != -1) {
      final removed = _comments.removeAt(topIndex);

      _listKey.currentState?.removeItem(
        topIndex,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1,
          child: FadeTransition(
            opacity: animation,
            child: CommentItem(
              key: ValueKey(removed['id']),
              comment: removed,
              onEdit: _editComment,
              onDelete: (id) {}, // no-op during animation
              onReply: _startReply,
              onReport: _reportComment,
              onHide: _hideComment,
              currentUserId: widget.currentUserId,
            ),
          ),
        ),
        duration: const Duration(milliseconds: 300),
      );

      showCustomSnackBar(context, "Comment deleted successfully", true);
      widget.onCommentDeleted();
      return;
    }

    for (var c in _comments) {
      final before = c["replies"].length;
      c["replies"].removeWhere((r) => r["id"] == id);
      if (c["replies"].length < before) {
        setState(() {});
        showCustomSnackBar(context, "Comment deleted successfully", true);
        widget.onCommentDeleted();
        return;
      }
    }

    showCustomSnackBar(context, "Failed to delete comment", false);
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() => _isLoadingMore = true);

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      List<Map<String, dynamic>> newComments = List.generate(_limit, (index) {
        final number = (_page - 1) * _limit + index + 1;
        return {
          "id": UniqueKey().toString(),
          "user": "User $number",
          "text": "Sample comment #$number",
          "time": DateTime.now().subtract(Duration(minutes: number * 5)),
          "replies": <Map<String, dynamic>>[],
        };
      });

      if (newComments.isEmpty) {
        if (!mounted) return;
        setState(() => _hasMore = false);
      } else {
        setState(() {
          for (var c in newComments) {
            _comments.add(c);
            final insertIndex = _comments.length - 1;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _listKey.currentState?.insertItem(insertIndex);
            });
          }
          _page++;
        });
      }
    } catch (e) {
      if (!mounted) return;
      showCustomSnackBar(context, "Error loading comments: $e", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.95;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        height: maxHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 8),
            CommentsHeader(reactionsCount: widget.reactionsCount),
            const Divider(height: 1),
            Expanded(
              child: CommentsList(
                comments: _comments,
                listKey: _listKey,
                onEdit: _editComment,
                onDelete: _deleteComment,
                onReply: _startReply,
                onReport: _reportComment,
                onHide: _hideComment,
                currentUserId: widget.currentUserId,
                scrollController: _scrollController,
              ),
            ),
            CommentInputField(
              controller: _controller,
              onSend: _addComment,
              focusNode: _focusNode,
              replyingTo: _replyToUser,
              onCancelReply: _cancelReply,
            ),
          ],
        ),
      ),
    );
  }
}
