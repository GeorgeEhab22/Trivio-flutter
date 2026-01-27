import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/presentation/home/posts_in_timeline/buttom_sheets/report_reasons_buttom_sheet.dart';
import 'package:auth/presentation/home/posts_in_timeline/buttom_sheets/widgets/list_action_tile.dart';
import 'package:auth/presentation/home/posts_in_timeline/buttom_sheets/widgets/square_action_button.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:auth/common/functions/copy_to_clipboard.dart';
import 'package:go_router/go_router.dart';

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
    final handleBarColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]
        : Colors.grey[300];
    final cubit = context.read<PostInteractionCubit>();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                  // save post => doneeeeeeeee
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
                      return SquareActionButton(
                        label: isSaved ? 'Saved' : 'Save',
                        icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                        backgroundColor: Theme.of(context).cardColor,
                        iconColor: Theme.of(context).iconTheme.color,
                        textColor: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color,
                        onTap: () {
                          cubit.toggleSavePost(
                            postId: post.postID ?? '',
                            userId: currentUserId,
                            currentSavedStatus: isSaved,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  SquareActionButton(
                    label: 'Copy Link',
                    icon: Icons.link_outlined,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                        ? Colors.white10
                        : const Color(0xFFF5F5F5),
                    iconColor: Theme.of(context).iconTheme.color,
                    textColor: Theme.of(context).textTheme.bodyMedium?.color,
                    onTap: () {
                      //TODO : later copy the right post link..
                      copyToClipboard(context, post.caption ?? 'No Link');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),

            // Options List
            // if (post.isEdited)
            //   ListActionTile(
            //     icon: Icons.history,
            //     text: 'View Edit History',
            //     color: Theme.of(context).iconTheme.color!,
            //     onTap: () {
            //       context.pop();
            //       // TODO : go to View Edit History page
            //     },
            //   ),

            ListActionTile(
              icon: Icons.visibility_off_outlined,
              text: 'Not Interested',
              color: Theme.of(context).iconTheme.color!,
              onTap: () {
                // TODO use the cubit to mark the post as not interested
              },
            ),

            // report => doneeeeeeeee
            ListActionTile(
              icon: Icons.report_gmailerrorred_outlined,
              text: 'Report',
              color: Colors.redAccent,
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
                            postId: post.postID??'',
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

            // if (post.authorId == currentUserId)
            ListActionTile(
              icon: Icons.delete_rounded,
              text: 'Delete',
              color: Colors.red,
              onTap: () {
                final postCubit = context.read<PostCubit>();
                context.pop();
                showCustomDialog(
                  context: context,
                  title: "Delete Post",
                  content: "Are you sure you want to delete this post?",
                  confirmText: "Delete",
                  confirmTextColor: Colors.red,
                  onConfirm: () {
                    postCubit.deletePost(post: post);
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
