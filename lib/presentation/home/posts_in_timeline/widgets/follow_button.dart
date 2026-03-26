import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_cubit.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';

class FollowButton extends StatelessWidget {
  final String currentUserId;
  final String authorId;

  const FollowButton({super.key, required this.currentUserId, required this.authorId});

  @override
  Widget build(BuildContext context) {
    if (currentUserId == authorId) return const SizedBox.shrink();

    return BlocConsumer<FollowCubit, FollowState>(
      listener: (context, state) {
        if (state is FollowFailure) {
          showCustomSnackBar(context, state.message, false);
          context.read<ProfileSocialInfoCubit>().fetchFollowing();
        }
        if (state is FollowSuccess || state is UnfollowSuccess) {
          context.read<ProfileSocialInfoCubit>().fetchFollowing();
          try {
            context.read<ProfileCubit>().loadProfile(isRefresh: true);
          } catch (e) {
            debugPrint("ProfileCubit not found in this context, skipping count refresh.");
          }
        }
      },
      builder: (context, followState) {
        final bool isProcessing = followState is FollowLoading;
        return BlocBuilder<ProfileSocialInfoCubit, ProfileSocialInfoState>(
          buildWhen: (previous, current) {
            if (previous is SocialInfoLoaded && current is SocialInfoLoaded) {
              return previous.following.length != current.following.length;
            }
            return true;
          },
          builder: (context, socialState) {
            bool isFollowing = false;
            if (socialState is SocialInfoLoaded) {
              isFollowing = socialState.following.any(
                (f) => f.user.id.toString().trim() == authorId.toString().trim()
              );
            }

            final l10n = AppLocalizations.of(context)!;

            return SizedBox(
              height: 30,
              child: TextButton(
                onPressed:isProcessing 
                ? null : () {
                  context.read<ProfileSocialInfoCubit>().toggleFollowOptimistically(
                    authorId, 
                    isFollowing,
                  );
                  if (isFollowing) {
                    context.read<FollowCubit>().unfollowUser(authorId);
                  } else {
                    context.read<FollowCubit>().followUser(authorId);
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: isFollowing ? Colors.transparent : Theme.of(context).cardColor,
                  side: isFollowing ? BorderSide(color: Theme.of(context).iconTheme.color!) : BorderSide.none,
                  padding: EdgeInsets.symmetric(horizontal: isFollowing ? 18 : 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
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