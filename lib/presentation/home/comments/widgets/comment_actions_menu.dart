import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auth/constants/colors';

class CommentActionsMenu extends StatefulWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReply;
  final VoidCallback onReport;
  final VoidCallback onHide;

  final String commentText;
  final BuildContext parentContext;

  final bool isOwner;

  const CommentActionsMenu({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onReply,
    required this.onReport,
    required this.onHide,
    required this.commentText,
    required this.parentContext,
    required this.isOwner,
  });

  @override
  State<CommentActionsMenu> createState() => _CommentActionsMenuState();
}

class _CommentActionsMenuState extends State<CommentActionsMenu> {
  void _showActions() {
    showModalBottomSheet(
      context: widget.parentContext,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              _actionTile(
                icon: Icons.reply_outlined,
                label: 'Reply',
                onTap: () {
                  Navigator.pop(widget.parentContext);
                  widget.onReply();
                },
              ),

              _divider(),

              _actionTile(
                icon: Icons.copy_outlined,
                label: 'Copy comment',
                onTap: () async {
                  await Clipboard.setData(
                    ClipboardData(text: widget.commentText),
                  );
                  Navigator.pop(widget.parentContext);
                  showCustomSnackBar(
                    widget.parentContext,
                    'Comment copied',
                    true,
                  );
                },
              ),

              _divider(),

              if (widget.isOwner) ...[
                _actionTile(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  onTap: () {
                    Navigator.pop(widget.parentContext);
                    widget.onEdit();
                  },
                ),

                _divider(),

                _actionTile(
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  textColor: Colors.redAccent,
                  iconColor: Colors.redAccent,
                  onTap: () {
                    Navigator.pop(widget.parentContext);
                    widget.onDelete();
                  },
                ),
              ],

              if (!widget.isOwner) ...[
                _actionTile(
                  icon: Icons.flag_outlined,
                  label: 'Report comment',
                  onTap: () {
                    Navigator.pop(widget.parentContext);
                    widget.onReport();
                  },
                ),

                _divider(),

                _actionTile(
                  icon: Icons.hide_source_outlined,
                  label: 'Hide comment',
                  onTap: () {
                    Navigator.pop(widget.parentContext);
                    widget.onHide();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() => Divider(height: 1, color: Colors.grey[200]);

  Widget _actionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: textColor ?? Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_vert, color: Colors.grey[700]),
      onPressed: _showActions,
    );
  }
}
