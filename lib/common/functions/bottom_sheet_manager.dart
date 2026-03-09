import 'package:auth/common/functions/copy_to_clipboard.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auth/l10n/app_localizations.dart';

class BottomSheetManager {
  static void showMediaSourceSheet(
    BuildContext context,
    bool isVideo, {
    required void Function(List<XFile> files) onPicked,
  }) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
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
                  title: Text(l10n.chooseFromGallery),
                  onTap: () async {
                    sheetContext.pop();
                    await pickMedia(
                      context: context,
                      isVideo: isVideo,
                      fromCamera: false,
                      onError: (message) {
                        if (context.mounted) {
                          showCustomSnackBar(context, message, false);
                        }
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
                  title: Text(l10n.useCamera),
                  onTap: () async {
                    sheetContext.pop();
                    await pickMedia(
                      context: context,
                      isVideo: isVideo,
                      fromCamera: true,
                      onError: (message) {
                        if (context.mounted) {
                          showCustomSnackBar(context, message, false);
                        }
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
    required BuildContext context,
    required bool isVideo,
    required bool fromCamera,
    required void Function(List<XFile> files) onPicked,
    required void Function(String message) onError,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final ImagePicker picker = ImagePicker();
      if (isVideo) {
        final XFile? video = await picker.pickVideo(
          source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        );
        if (video != null) onPicked([video]);
      } else {
        if (fromCamera) {
          final XFile? photo = await picker.pickImage(
            source: ImageSource.camera,
          );
          if (photo != null) onPicked([photo]);
        } else {
          final List<XFile> photos = await picker.pickMultiImage();
          if (photos.isNotEmpty) onPicked(photos);
        }
      }
    } catch (e) {
      onError("${l10n.errorPickingMedia}: $e");
    }
  }

  static Future<void> showPrivacyOptions(
    BuildContext context,
    Function(String) onChange,
  ) async {
    final l10n = AppLocalizations.of(context)!;
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
                title: Text(l10n.privacyPublic),
                onTap: () => context.pop('Public'),
                iconColor: Theme.of(context).iconTheme.color,
                textColor: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: Text(l10n.privacyPrivate),
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
    final l10n = AppLocalizations.of(context)!;
    final handleBarColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]
        : Colors.grey[300];

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  color: handleBarColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (isOwner) ...[
                if (!comment.isReply) ...[
                  actionTile(
                    icon: Icons.reply_outlined,
                    label: l10n.reply,
                    textColor: Theme.of(context).textTheme.bodyMedium?.color,
                    onTap: () {
                      context.pop();
                      cubit.triggerReply(comment);
                    },
                  ),
                  divider(),
                ],
                actionTile(
                  icon: Icons.copy_outlined,
                  label: l10n.copyComment,
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  onTap: () async {
                    context.pop();
                    copyToClipboard(context, comment.text);
                  },
                ),
                divider(),
                actionTile(
                  icon: Icons.delete_outline,
                  label: l10n.delete,
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  iconColor: Colors.redAccent,
                  onTap: () {
                    context.pop();
                    cubit.deleteComment(comment.id);
                  },
                ),
                divider(),
                
                  actionTile(
                    icon: Icons.edit_outlined,
                    label: l10n.edit,
                    textColor: Theme.of(context).textTheme.bodyMedium?.color,
                    onTap: () {
                      context.pop();
                      cubit.triggerEdit(comment);
                    },
                  ),
               
              ],
              if (!isOwner) ...[
                if (!comment.isReply) ...[
                  actionTile(
                    icon: Icons.reply_outlined,
                    label: l10n.reply,
                    textColor: Theme.of(context).textTheme.bodyMedium?.color,
                    onTap: () {
                      context.pop();
                      cubit.triggerReply(comment);
                    },
                  ),
                  divider(),
                ],
                actionTile(
                  icon: Icons.copy_outlined,
                  label: l10n.copyComment,
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  onTap: () async {
                    context.pop();
                    copyToClipboard(context, comment.text);
                  },
                ),
                divider(),
                actionTile(
                  icon: Icons.flag_outlined,
                  label: l10n.reportComment,
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  onTap: () {
                    context.pop();
                    cubit.reportComment(comment.id);
                  },
                ),
                divider(),
                actionTile(
                  icon: Icons.hide_source_outlined,
                  label: l10n.hideComment,
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
