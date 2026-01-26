import 'package:auth/common/functions/copy_to_clipboard.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/home/comments/pages/comment_edit_page.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class BottomSheetManager {
  
  static void showMediaSourceSheet(
    BuildContext context,
    bool isVideo, {
    required Null Function(dynamic files) onPicked,
  }) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  leading: Icon(
                    Icons.photo_library,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: const Text("Choose from Gallery"),
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  onTap: () {
                    context.pop();
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
                  leading: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: const Text("Use Camera"),
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  onTap: () {
                    context.pop();
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
      useRootNavigator: true,
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
                onTap: () => context.pop('Public'),
                iconColor: Theme.of(context).iconTheme.color,
                textColor: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text("Private"),
                onTap: () => context.pop('Private'),
                iconColor: Theme.of(context).iconTheme.color,
                textColor: Theme.of(context).textTheme.bodyMedium?.color,
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


// TODO : handle states 
  static void showActions(
    BuildContext context, {
    required Comment comment,
    required bool isOwner,
    required CommentCubit cubit,
  }) {
    final handleBarColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]
        : Colors.grey[300];
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor:Theme.of( context).scaffoldBackgroundColor,
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
                  color:handleBarColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (isOwner) ...[
                actionTile(
                  icon: Icons.reply_outlined,
                  label: 'Reply',
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  onTap: () {
                    context.pop();
                    cubit.triggerReply(comment);
                  },
                ),

                divider(),

                actionTile(
                  icon: Icons.copy_outlined,
                  label: 'Copy comment',
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  onTap: () async {
                    context.pop();
                    copyToClipboard(context, comment.text);
                  },
                ),

                divider(),

                actionTile(
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  iconColor: Colors.redAccent,
                  onTap: () {
                    context.pop();
                    cubit.deleteComment(comment.id);
                  },
                ),

                divider(),

                if (comment.editedAt == null)
                  actionTile(
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    textColor: Theme.of(context).textTheme.bodyMedium?.color,
                    onTap: () {
                      context.pop();
                      navigateToEditPage(context, comment, cubit);
                    },
                  ),

                if (comment.editedAt != null)
                  actionTile(
                    icon: Icons.history,
                    label: 'View Edit History',
                    textColor: Theme.of(context).textTheme.bodyMedium?.color,
                    onTap: () {
                      context.pop();
                      //cubit.showHistory(comment.id);
                    },
                  ),
              ],
              if (!isOwner) ...[
                actionTile(
                  icon: Icons.reply_outlined,
                  label: 'Reply',
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  onTap: () {
                    context.pop();
                    cubit.triggerReply(comment);
                  },
                ),

                divider(),

                actionTile(
                  icon: Icons.copy_outlined,
                  label: 'Copy comment',
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  onTap: () async {
                    context.pop();
                    copyToClipboard(context, comment.text);
                  },
                ),

                divider(),

                actionTile(
                  icon: Icons.flag_outlined,
                  label: 'Report comment',
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  onTap: () {
                    context.pop();
                    cubit.reportComment(comment.id);
                  },
                ),

                divider(),

                actionTile(
                  icon: Icons.hide_source_outlined,
                  label: 'Hide comment',
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  onTap: () {
                    context.pop();
                    cubit.hideComment(comment.id);
                  },
                ),
              ],
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
    Color? textColor,
    Color? iconColor,
    VoidCallback? onTap,
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
}
