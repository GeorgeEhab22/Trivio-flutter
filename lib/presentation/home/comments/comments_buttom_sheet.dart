import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        _loadMore();
      }
    });
    _loadMore();
  }

  void _addComment(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      if (_replyToId != null) {
        final parentIndex = _comments.indexWhere((c) => c["id"] == _replyToId);
        if (parentIndex != -1) {
          _comments[parentIndex]["replies"].insert(0, {
            "id": UniqueKey().toString(),
            "user": "You",
            "text": text.trim(),
            "time": DateTime.now(),
            "replies": <Map<String, dynamic>>[],
          });
        }
        _replyToId = null;
        _replyToUser = null;
      } else {
        final newComment = {
          "id": UniqueKey().toString(),
          "user": "You",
          "text": text.trim(),
          "time": DateTime.now(),
          "replies": <Map<String, dynamic>>[],
        };
        _comments.insert(0, newComment);
        _listKey.currentState?.insertItem(0);
      }
    });

    _controller.clear();
    widget.onCommentAdded();
  }

  void _reportComment(String id) {
    //print("Report comment $id");
  }

  void _hideComment(String id) {
    //print("Hide comment $id");
  }

  void _startReply(String id, String username) {
    setState(() {
      _replyToId = id;
      _replyToUser = username;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    bool deleted = false;

    setState(() {
      final originalLength = _comments.length;
      _comments.removeWhere((c) => c["id"] == id);
      if (_comments.length < originalLength) {
        deleted = true;
        return;
      }

      for (var c in _comments) {
        final beforeReplies = c["replies"].length;
        c["replies"].removeWhere((r) => r["id"] == id);
        if (c["replies"].length < beforeReplies) {
          deleted = true;
          break;
        }
      }
    });

    if (deleted) {
      showCustomSnackBar(context, "Comment deleted successfully", true);
      widget.onCommentDeleted();
    } else {
      showCustomSnackBar(context, "Failed to delete comment", false);
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() => _isLoadingMore = true);

    await Future.delayed(const Duration(seconds: 1));
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
      setState(() => _hasMore = false);
    } else {
      setState(() {
        for (var c in newComments) {
          final index = _comments.length;
          _comments.add(c);
          _listKey.currentState?.insertItem(index);
        }
        _page++;
      });
    }

    setState(() => _isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.95,
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
