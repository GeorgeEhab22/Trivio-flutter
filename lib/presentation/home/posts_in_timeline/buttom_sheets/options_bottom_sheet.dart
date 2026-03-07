import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/home/posts_in_timeline/buttom_sheets/report_reasons_buttom_sheet.dart';
import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:auth/common/functions/copy_to_clipboard.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/l10n/app_localizations.dart';

class OptionsBottomSheet extends StatelessWidget {
  final Post post;
  final String currentUserId;

  const OptionsBottomSheet({
    super.key,
    required this.post,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final handleBarColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]
        : Colors.grey[300];
    final cubit = context.read<PostInteractionCubit>();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              width: 45,
              height: 5,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: handleBarColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),

            // Top Buttons Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<PostInteractionCubit, PostInteractionState>(
                    buildWhen: (previous, current) {
                      return current is PostSaveUpdated ||
                          current is SavePostSuccess ||
                          current is SavePostError;
                    },
                    builder: (context, state) {
                      bool isSaved = post.flagged ?? false;

                      if (state is PostSaveUpdated) {
                        isSaved = state.isSaved;
                      } else if (state is SavePostSuccess) {
                        isSaved = state.isSaved;
                      } else if (state is SavePostError) {
                        isSaved = state.oldStatus;
                      }
                      return Expanded(
                        child: CustomSquareButton(
                          label: isSaved ? l10n.saved : l10n.save,
                          icon: isSaved
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          backgroundColor: Theme.of(context).cardColor,
                          onTap: () {
                            cubit.toggleSavePost(
                              postId: post.postID ?? '',
                              userId: currentUserId,
                              currentSavedStatus: isSaved,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomSquareButton(
                      label: l10n.copyLink,
                      icon: Icons.link_outlined,
                      backgroundColor: Theme.of(context).cardColor,
                      onTap: () {
                        copyToClipboard(context, post.caption ?? l10n.noLink);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            if (post.authorId == currentUserId)
            CustomListTile(
              icon: Icons.edit_outlined,
              text: l10n.edit,
              onTap: () {
                final groupCubit = post.location == 'group'
                    ? context.read<GroupPostsCubit>()
                    : null;

                context.pop();

                context.push(
                  AppRoutes.editPostCaption,
                  extra: {'post': post, 'groupCubit': groupCubit},
                );
              },
            ),
            CustomListTile(
              icon: Icons.visibility_off_outlined,
              text: 'Not Interested',
              onTap: () {
                // TODO use the cubit to mark the post as not interested
              },
            ),

            CustomListTile(
              icon: Icons.report_gmailerrorred_outlined,
              text: l10n.report,
              redColor: true,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  builder: (ctx) {
                    return BlocProvider.value(
                      value: cubit,
                      child: ReportReasonsBottomSheet(
                        onReportSelected: (reason) {
                          cubit.reportPost(
                            postId: post.postID ?? '',
                            userId: currentUserId,
                            reason: reason,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),

            if (post.authorId == currentUserId)
            CustomListTile(
              icon: Icons.delete_rounded,
              text: l10n.delete,
              redColor: true,
              onTap: () {
                final groupCubit = post.location == 'group'
                    ? context.read<GroupPostsCubit>()
                    : null;
                final postCubit = context.read<PostCubit>();
                context.pop();
                showCustomDialog(
                  context: context,
                  title: l10n.deletePostTitle,
                  content: l10n.deletePostConfirm,
                  confirmText: l10n.delete,
                  confirmTextColor: Colors.red,
                  onConfirm: () {
                    if (post.location == 'group' && groupCubit != null) {
                      groupCubit.deletePost(
                        groupId: post.groupID ?? "",
                        post: post,
                      );
                    } else {
                      postCubit.deletePost(post: post);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
