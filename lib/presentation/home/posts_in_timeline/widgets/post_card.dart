import 'dart:ui';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_content.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_footer.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_header.dart';
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

  final ValueNotifier<bool> isRevealed = ValueNotifier<bool>(false);

  PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
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
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final isFlagged = post.flagged ?? false;
        final postCubitState = context.watch<PostCubit>().state;
        bool isDeleting = postCubitState is DeletePostLoading && postCubitState.postId == post.postID;
        final isReportLoading = state is ReportPostLoading && state.postId == post.postID;

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: (isDeleting || isReportLoading) ? 0.55 : 1,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black38 : const Color(0xFF0F172A).withValues(alpha: 0.08),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: ValueListenableBuilder<bool>(
                valueListenable: isRevealed,
                builder: (context, revealed, _) {
                  final showBlur = isFlagged && !revealed;

                  return Stack(
                    children: [
                      _buildCardBody(context, isDark),
                      if (showBlur)
                        Positioned.fill(
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                              child: Container(
                                color: isDark 
                                    ? Colors.black.withValues(alpha: 0.4) 
                                    : Colors.white.withValues(alpha: 0.2),
                                child: _buildBlurControls(context, isDark),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildCardBody(BuildContext context, bool isDark) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
              ? const [Color(0xFF1D2228), Color(0xFF171B20)] 
              : const [Color(0xFFFFFFFF), Color(0xFFF8FBF9)],
        ),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopGlowBar(isDark),
          PostHeader(post: post, currentUserId: currentUserId),
          PostContent(post: post),
          const SizedBox(height: 10),
          _buildDivider(isDark),
          PostFooter(
            post: post,
            currentUserId: currentUserId,
            currentReaction: currentReaction ?? post.userReaction,
          ),
        ],
      ),
    );
  }

  Widget _buildBlurControls(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.visibility_off_rounded,
          color: isDark ? Colors.white70 : Colors.black54,
          size: 40,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.sensitiveContent,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => isRevealed.value = true,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(l10n.seePost),
        ),
      ],
    );
  }

  Widget _buildTopGlowBar(bool isDark) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [AppColors.primary.withAlpha(200), AppColors.darkGreen] 
            : [AppColors.primary, AppColors.darkGreen],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 0.7,
      indent: 12,
      endIndent: 12,
      color: isDark
          ? Colors.white.withValues(alpha: 0.09)
          : const Color(0xFFE8ECEF),
    );
  }
}