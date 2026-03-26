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

  const FollowButton({
    super.key,
    required this.currentUserId,
    required this.authorId,
  });

  @override
  Widget build(BuildContext context) {
    if (currentUserId == authorId) return const SizedBox.shrink();

    return BlocConsumer<FollowCubit, FollowState>(
      listener: (context, state) {
        if (state is FollowSuccess || state is UnfollowSuccess) {
          context.read<ProfileSocialInfoCubit>().fetchFollowing();
        }
        if (state is FollowFailure) {
          context.read<ProfileSocialInfoCubit>().fetchFollowing();
          //TODO: show real error on failure
          //showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, followState) {
        return BlocBuilder<ProfileSocialInfoCubit, ProfileSocialInfoState>(
          builder: (context, socialState) {
            bool isFollowing = false;

            if (socialState is SocialInfoLoaded) {
              isFollowing = socialState.following.any(
                (f) => f.user.id.toString().trim() == authorId.toString().trim()
              );
            }

            final isActionLoading = followState is FollowLoading;
            final l10n = AppLocalizations.of(context)!;

            return SizedBox(
              height: 30,
              child: TextButton(
                onPressed: isActionLoading 
                  ? null 
                  : () {
                      if (isFollowing) {
                        context.read<FollowCubit>().unfollowUser(authorId);
                      } else {
                        context.read<FollowCubit>().followUser(authorId);
                      }
                    },
                style: TextButton.styleFrom(
                  backgroundColor: isFollowing 
                      ? Colors.transparent 
                      : Theme.of(context).cardColor,
                  side: isFollowing 
                      ? BorderSide(color: Theme.of(context).iconTheme.color!) 
                      : BorderSide.none,
                  padding: EdgeInsets.symmetric(horizontal: isFollowing ? 18 : 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: isActionLoading
                    ? const SizedBox(
                        width: 14, 
                        height: 14, 
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        isFollowing ? l10n.following : l10n.follow,
                        style: Styles.textStyle14.copyWith(
                          color: isFollowing 
                              ? Theme.of(context).iconTheme.color 
                              : Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}