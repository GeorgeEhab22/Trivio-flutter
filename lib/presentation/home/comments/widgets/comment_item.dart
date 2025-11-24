import 'package:flutter/material.dart';
import 'package:auth/presentation/home/comments/widgets/comment_header.dart';
import 'package:auth/presentation/home/comments/widgets/comment_body.dart';
import 'package:auth/presentation/home/comments/widgets/comment_replies_list.dart';

class CommentItem extends StatefulWidget {
  final Map<String, dynamic> comment;

  final void Function(String id, String newText) onEdit;
  final void Function(String id) onDelete;
  final void Function(String id, String username) onReply;

  final void Function(String id) onReport;
  final void Function(String id) onHide;

  final String currentUserId;

  final String? replyingTo;
  final bool isReply;

  const CommentItem({
    super.key,
    required this.comment,
    required this.onEdit,
    required this.onDelete,
    required this.onReply,
    required this.onReport,
    required this.onHide,
    required this.currentUserId,
    this.replyingTo,
    this.isReply = false,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _showReplies = false;

  void _showEditDialog(String id, String oldText) {
    final controller = TextEditingController(text: oldText);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Comment"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Edit your comment...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onEdit(id, controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.comment;
    final replies = List<Map<String, dynamic>>.from(c["replies"] ?? []);

    final bool isOwner = c["userId"] == widget.currentUserId;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentHeader(
          user: c["user"],
          userImage: c["userImage"],
          time: c["time"],
          commentText: c["text"],

          isOwner: isOwner,

          onReply: () => widget.onReply(c["id"], c["user"]),
          onEdit: () => _showEditDialog(c["id"], c["text"]),
          onDelete: () => widget.onDelete(c["id"]),

          onReport: () => widget.onReport(c["id"]),
          onHide: () => widget.onHide(c["id"]),
        ),

        if (widget.replyingTo != null && widget.replyingTo!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 54, bottom: 4),
            child: Text(
              "Replying to ${widget.replyingTo}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

        CommentBody(
          text: c["text"],
          onReply: () => widget.onReply(c["id"], c["user"]),
          showReplies: _showReplies,
          repliesCount: replies.length,
          onToggleReplies: () => setState(() {
            _showReplies = !_showReplies;
          }),
          onReactionChanged: (int value) {},
        ),

        if (replies.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
              left: widget.isReply ? 50 : 60,
              top: 4,
              bottom: 4,
            ),
            child: GestureDetector(
              onTap: () => setState(() => _showReplies = !_showReplies),
              child: Row(
                children: [
                  Icon(
                    _showReplies
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _showReplies
                        ? "Hide replies"
                        : "View ${replies.length} replies",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

        if (_showReplies)
          CommentRepliesList(
            currentUserId: widget.currentUserId,
            onReport: widget.onReport,
            onHide: widget.onHide,
            replies: replies,
            onEdit: (id, text) => _showEditDialog(id, text),
            onDelete: widget.onDelete,
            onReply: widget.onReply,
          ),
      ],
    );

    return widget.isReply
        ? Transform.scale(
            scale: 0.95,
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 50, bottom: 6),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: content,
            ),
          )
        : content;
  }
}
