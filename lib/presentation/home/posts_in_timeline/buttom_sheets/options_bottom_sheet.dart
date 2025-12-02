import 'package:auth/constants/colors.dart';
import 'package:auth/presentation/home/posts_in_timeline/buttom_sheets/report_reasons_buttom_sheet.dart';
import 'package:auth/presentation/home/posts_in_timeline/buttom_sheets/widgets/list_action_tile.dart';
import 'package:auth/presentation/home/posts_in_timeline/buttom_sheets/widgets/square_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:auth/common/functions/copy_to_clipboard.dart';

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
    final grey300 = Colors.grey[300] ?? const Color(0xFFD6D6D6);

    final cubit = context.read<PostInteractionCubit>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
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
                color: grey300,
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
                      bool isSaved = post.isSaved;

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
                        backgroundColor: Color(0xFFF5F5F5),
                        iconColor: AppColors.iconsColor,
                        textColor: Colors.black87,
                        onTap: () {
                          cubit.toggleSavePost(
                            postId: post.id,
                            userId: currentUserId,
                            currentSavedStatus: isSaved,
                          );
                          context.pop();
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  SquareActionButton(
                    label: 'Copy Link',
                    icon: Icons.link_outlined,
                    backgroundColor: Color(0xFFF5F5F5),
                    onTap: () {
                      context.pop();
                      //TODO : later copy the right post link..
                      copyToClipboard(context, post.content);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),

            // Options List
            if (post.isEdited)
              ListActionTile(
                icon: Icons.history,
                text: 'View Edit History',
                onTap: () {
                  context.pop();
                  // TODO : go to View Edit History page
                },
              ),

            ListActionTile(
              icon: Icons.visibility_off_outlined,
              text: 'Not Interested',
              onTap: () {
                context.pop();
                // TODO use the cubit to mark the post as not interested
              },
            ),

            // report => doneeeeeeeee
            ListActionTile(
              icon: Icons.report_gmailerrorred_outlined,
              text: 'Report',
              color: Colors.redAccent,
              onTap: () {
                context.pop();
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (ctx) {
                    return BlocProvider.value(
                      value: cubit,
                      child: ReportReasonsBottomSheet(
                        onReportSelected: (reason) {
                          ctx.pop();
                          cubit.reportPost(
                            postId: post.id,
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
              ListActionTile(
                icon: Icons.delete_outline,
                text: 'Delete Post',
                color: Colors.red,
                onTap: () {
                  context.pop();
                  cubit.deletePost(post: post);
                },
              ),
          ],
        ),
      ),
    );
  }
}
