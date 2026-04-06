import 'package:auth/constants/colors.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_cubit.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';

class FollowButton extends StatelessWidget {
  final String currentUserId;
  final String authorId;
  final bool isFollowing;
  final bool isReel;

  const FollowButton({
    super.key,
    required this.currentUserId,
    required this.authorId,
    required this.isFollowing,
    this.isReel = false,
  });

  @override
  Widget build(BuildContext context) {
    if (currentUserId == authorId) return const SizedBox.shrink();

    return BlocListener<FollowCubit, FollowState>(
      listener: (context, state) {
        if (state is FollowFailure) {
          showCustomSnackBar(context, state.message, false);
        }
        if (state is FollowSuccess || state is UnfollowSuccess) {
          context.read<ProfileSocialInfoCubit>().fetchFollowing();
        }
      },
      child: BlocBuilder<ProfileSocialInfoCubit, ProfileSocialInfoState>(
        builder: (context, socialState) {
          bool effectiveFollowing = isFollowing;

          if (socialState is SocialInfoLoaded) {
            effectiveFollowing = socialState.following.any(
              (f) => f.user.id.toString().trim() == authorId.toString().trim(),
            );
          }

          final bool isProcessing =
              context.watch<FollowCubit>().state is FollowLoading;
          final l10n = AppLocalizations.of(context)!;

          return SizedBox(
            height: 30,
            child: TextButton(
              onPressed: isProcessing
                  ? null
                  : () {
                      context
                          .read<ProfileSocialInfoCubit>()
                          .toggleFollowOptimistically(
                            authorId,
                            effectiveFollowing,
                          );

                      if (effectiveFollowing) {
                        context.read<FollowCubit>().unfollowUser(authorId);
                      } else {
                        context.read<FollowCubit>().followUser(authorId);
                      }
                    },
              style: TextButton.styleFrom(
                backgroundColor: isReel
                    ? Colors.transparent
                    : (effectiveFollowing
                          ? Colors.transparent
                          : Theme.of(context).cardColor),
                side: isReel
                    ? BorderSide(color: AppColors.primary, width: 1.2)
                    : (effectiveFollowing
                          ? BorderSide(
                              color: Theme.of(context).iconTheme.color!,
                            )
                          : BorderSide.none),
                padding: EdgeInsets.symmetric(
                  horizontal: effectiveFollowing ? 18 : 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isProcessing
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      effectiveFollowing ? l10n.following : l10n.follow,
                      style: Styles.textStyle14.copyWith(
                        color: isReel
                            ? Colors.white
                            : (effectiveFollowing
                                  ? Theme.of(context).iconTheme.color
                                  : Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
