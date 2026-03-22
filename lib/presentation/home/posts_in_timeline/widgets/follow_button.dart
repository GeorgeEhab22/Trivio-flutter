import 'package:auth/injection_container.dart' as di;
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_cubit.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';

class FollowButton extends StatelessWidget {
  final String currentUserId;
  final String authorId;
  final bool initialFollowStatus;

  const FollowButton({
    super.key,
    required this.currentUserId,
    required this.authorId,
    required this.initialFollowStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (currentUserId == authorId) return const SizedBox.shrink();

    return BlocProvider(
      create: (context) => di.sl<FollowCubit>(),
      child: BlocConsumer<FollowCubit, FollowState>(
        listener: (context, state) {
          if (state is FollowFailure) {
            showCustomSnackBar(context, state.message, false);
          }
        },
        buildWhen: (previous, current) {
          return current is FollowSuccess || current is FollowLoading || current is FollowFailure;
        },
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          
          bool isFollowing = initialFollowStatus;
          
          if (state is FollowSuccess) {

            isFollowing = state.follow != null; 
          }

          final isLoading = state is FollowLoading;

          return SizedBox(
            height: 30,
            child: TextButton(
              onPressed: isLoading
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
                padding: EdgeInsets.symmetric(
                  horizontal: isFollowing ? 18 : 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoading 
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
      ),
    );
  }
}