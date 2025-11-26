import 'package:auth/constants/colors';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/home/comments/comments_buttom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class BottomSheetManager {
  static void showMediaSourceSheet(
    BuildContext context,
    bool isVideo, {
    required Null Function(dynamic files) onPicked,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: AppColors.iconsColor,
                  ),
                  title: const Text("Choose from Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    pickMedia(
                      isVideo: isVideo,
                      fromCamera: false,
                      onError: (message) {
                        showCustomSnackBar(context, message, false);
                      },
                      onPicked: onPicked,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: AppColors.iconsColor,
                  ),
                  title: const Text("Use Camera"),
                  onTap: () {
                    Navigator.pop(context);
                    pickMedia(
                      isVideo: isVideo,
                      fromCamera: true,
                      onError: (message) {
                        showCustomSnackBar(context, message, false);
                      },
                      onPicked: onPicked,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> pickMedia({
    required bool isVideo,
    required bool fromCamera,
    required void Function(List<XFile> files) onPicked,
    required void Function(String message) onError,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      if (isVideo) {
        final XFile? pickedVideo = await picker.pickVideo(
          source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        );

        if (pickedVideo != null) {
          onPicked([pickedVideo]);
        }
      } else {
        final List<XFile> pickedImages = fromCamera
            ? [
                await picker.pickImage(source: ImageSource.camera),
              ].whereType<XFile>().toList()
            : await picker.pickMultiImage();

        if (pickedImages.isNotEmpty) {
          onPicked(pickedImages);
        }
      }
    } catch (e) {
      onError("Error picking media: $e");
    }
  }

  static Future<void> showPrivacyOptions(
    BuildContext context,
    Function(String) onChange,
  ) async {
    final String? selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.public),
                title: const Text("Public"),
                onTap: () => Navigator.pop(context, 'Public'),
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text("Private"),
                onTap: () => Navigator.pop(context, 'Private'),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      onChange(selected);
    }
  }

  static void showActions(
    BuildContext context, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required VoidCallback onReply,
    required VoidCallback onReport,
    required VoidCallback onHide,
    required String commentText,
    required bool isOwner,
  }) {
    showModalBottomSheet(
      context: context,
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

              actionTile(
                icon: Icons.reply_outlined,
                label: 'Reply',
                onTap: () {
                  Navigator.pop(context);
                  onReply();
                },
              ),

              divider(),

              actionTile(
                icon: Icons.copy_outlined,
                label: 'Copy comment',
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: commentText));
                  Navigator.pop(context);
                  showCustomSnackBar(context, 'Comment copied', true);
                },
              ),

              divider(),

              if (isOwner) ...[
                actionTile(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  onTap: () {
                    Navigator.pop(context);
                    onEdit();
                  },
                ),

                divider(),

                actionTile(
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  textColor: Colors.redAccent,
                  iconColor: Colors.redAccent,
                  onTap: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                ),
              ],


                actionTile(
                  icon: Icons.flag_outlined,
                  label: 'Report comment',
                  onTap: () {
                    Navigator.pop(context);
                    onReport();
                  },
                ),

                divider(),

                actionTile(
                  icon: Icons.hide_source_outlined,
                  label: 'Hide comment',
                  onTap: () {
                    Navigator.pop(context);
                    onHide();
                  },
                ),
              ],

          ),
        ),
      ),
    );
  }

  static Widget divider() => Divider(height: 1, color: Colors.grey[200]);

  static Widget actionTile({
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
  static void openComments(BuildContext context, {
    required int reactionsCount,
    required VoidCallback onCommentAdded,
    required VoidCallback onCommentDeleted,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black38,
      builder: (ctx) => CommentsBottomSheet(
        reactionsCount: reactionsCount,
        onCommentAdded: onCommentAdded,
        onCommentDeleted: onCommentDeleted,
      ),
    );
  }
}
