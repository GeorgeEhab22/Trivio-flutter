import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/home/posts_in_timeline/buttom_sheets/report_reasons_buttom_sheet.dart';
import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/get_reels/get_reels_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/saved_posts/saved_posts_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/saved_posts/saved_posts_state.dart';
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
  final bool isReelView;

  const OptionsBottomSheet({
    super.key,
    required this.post,
    required this.currentUserId,
    this.isReelView = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final handleBarColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]
        : Colors.grey[300];
    final cubit = context.read<PostInteractionCubit>();
    final savedPostsCubit = context.read<SavedPostsCubit>();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: SingleChildScrollView(
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: handleBarColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<SavedPostsCubit, SavedPostsState>(
                      builder: (context, state) {
                        bool isSaved = false;

                        if (state is SavedPostsLoaded) {
                          isSaved = state.savedPosts.any(
                            (p) => p.postID == post.postID,
                          );
                        }

                        return Expanded(
                          child: CustomSquareButton(
                            label: isSaved ? l10n.saved : l10n.save,
                            icon: isSaved
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            backgroundColor: Theme.of(context).cardColor,
                            onTap: () {
                              savedPostsCubit.toggleSavePost(post);
                              context.pop();
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
                          final String postUrl =
                              (post.location == 'group' && post.groupID != null)
                              ? "https://trivio.app/group/${post.groupID}/post/${post.postID}"
                              : "https://trivio.app/post/${post.postID}";
                          copyToClipboard(context, postUrl);
                          context.pop();
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
                  text: l10n.editPost,
                  onTap: () {
                    context.pop();
                    context.push(
                      AppRoutes.editCaption,
                      extra: {
                        'initialText': post.caption,
                        'title': l10n.editPost,
                        'onSave': (String newText) {
                          context.read<PostCubit>().editPost(
                            postId: post.postID,
                            newCaption: newText,
                          );

                          if (isReelView) {
                            context.read<ReelsCubit>().updateReelCaptionLocally(
                              post.postID,
                              newText,
                            );
                          }
                        },
                      },
                    );
                  },
                ),

              CustomListTile(
                icon: Icons.visibility_off_outlined,
                text: l10n.notInterested,
                onTap: () {
                  // TODO: use the cubit to mark the post as not interested
                  context.pop();
                },
              ),

              // Report
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
                              postId: post.postID,
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

              // Delete Post (Only show if current user is the author)
              if (post.authorId == currentUserId)
                CustomListTile(
                  icon: Icons.delete_rounded,
                  text: l10n.delete,
                  redColor: true,
                  onTap: () {
                    final groupCubit = context.read<GroupPostsCubit?>();
                    final postCubit = context.read<PostCubit?>();
                    final reelsCubit = context.read<ReelsCubit?>();

                    context.pop();

                    showCustomDialog(
                      context: context,
                      title: l10n.deletePostTitle,
                      content: l10n.deletePostConfirm,
                      confirmText: l10n.delete,
                      confirmTextColor: Colors.red,
                      onConfirm: () {
                        if (post.location == 'group') {
                          groupCubit?.deletePost(
                            groupId: post.groupID ?? "",
                            post: post,
                          );
                        } else if (isReelView) {
                          postCubit?.deletePost(post: post);
                          reelsCubit?.deleteReel(post: post);
                        } else {
                          postCubit?.deletePost(post: post);
                        }
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
