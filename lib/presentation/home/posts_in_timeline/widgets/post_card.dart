import 'package:auth/presentation/home/posts_in_timeline/widgets/post_content.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_footer.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_header.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_state.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/l10n/app_localizations.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final String currentUserId;
  final ReactionType? currentReaction;
  final bool isFollowing;

  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.isFollowing,
    this.currentReaction,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostInteractionCubit, PostInteractionState>(
      listener: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        if (state is ReportPostSuccess && state.postId == post.postID) {
          showCustomSnackBar(context, l10n.reportPostSuccess, true);
        }
        if (state is ReportPostError && state.postId == post.postID) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        final postCubitState = context.watch<PostCubit>().state;
        GroupPostsState? groupPostsState;
        try {
          groupPostsState = context.watch<GroupPostsCubit>().state;
        } catch (_) {}
        bool isDeleting = false;
        if (groupPostsState is GroupPostsDeleting) {
          isDeleting = groupPostsState.postId == post.postID;
        }
        if (postCubitState is DeletePostLoading) {
          isDeleting = isDeleting || postCubitState.postId == post.postID;
        }

        final isReportLoading =
            state is ReportPostLoading && state.postId == post.postID;
        final hasMetrics =
            post.reactionsCount > 0 || (post.media?.isNotEmpty ?? false);
        final isGroupPost = post.location == 'group';
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final borderColor = isDark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.black.withValues(alpha: 0.08);
        final cardGradient = isDark
            ? const [Color(0xFF1D2228), Color(0xFF171B20)]
            : const [Color(0xFFFFFFFF), Color(0xFFF8FBF9)];
        final shadowColor = isDark
            ? Colors.black.withValues(alpha: 0.38)
            : const Color(0xFF0F172A).withValues(alpha: 0.08);

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: (isDeleting || isReportLoading) ? 0.55 : 1,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: cardGradient,
                  ),
                  border: Border.all(color: borderColor),
                ),
                child: Stack(
                  children: [
                    PositionedDirectional(
                      end: -28,
                      top: -38,
                      child: Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withValues(
                                alpha: isDark ? 0.25 : 0.2,
                              ),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: isDark
                                    ? LinearGradient(
                                        colors: [
                                          Color(0xFF42C83C).withAlpha(900),
                                          AppColors.darkGreen,
                                        ],
                                      )
                                    : LinearGradient(
                                        colors: [
                                          Color(0xFF42C83C),
                                          AppColors.darkGreen,
                                        ],
                                      ),
                              ),
                            ),
                            PostHeader(
                              post: post,
                              currentUserId: currentUserId,
                              isFollowing: isFollowing,
                            ),
                            PostContent(post: post),
                            if (hasMetrics || isGroupPost) ...[
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                
                              ),
                            ],
                            const SizedBox(height: 10),
                            Divider(
                              height: 1,
                              thickness: 0.7,
                              indent: 12,
                              endIndent: 12,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.09)
                                  : const Color(0xFFE8ECEF),
                            ),
                            PostFooter(
                              post: post,
                              currentUserId: currentUserId,
                              currentReaction:
                                  currentReaction ?? post.userReaction,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

