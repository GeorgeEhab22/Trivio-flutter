import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';

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

    return BlocBuilder<PostInteractionCubit, PostInteractionState>(
      buildWhen: (previous, current) {
        return current is PostFollowUpdated ||
            current is FollowUserSuccess ||
            current is FollowUserError;
      },
      builder: (context, state) {
        bool isFollowing = initialFollowStatus;

        if (state is PostFollowUpdated) {
          isFollowing = state.isFollowing;
        } else if (state is FollowUserSuccess) {
          isFollowing = state.isFollowing;
        } else if (state is FollowUserError) {
          isFollowing = state.oldStatus;
        }

        return SizedBox(
          height: 30,
          child: TextButton(
            onPressed: () {
              context.read<PostInteractionCubit>().toggleFollowUser(
                    followerId: currentUserId,
                    followeeId: authorId,
                    currentFollowStatus: isFollowing,
                  );
            },
            style: TextButton.styleFrom(
              backgroundColor: isFollowing ? Colors.transparent : const Color(0xFFF5F5F5),
              side: isFollowing
                  ? BorderSide(color:Theme.of(context).iconTheme.color!)
                  : BorderSide.none,
              padding: EdgeInsets.symmetric(horizontal: isFollowing ? 18 : 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              isFollowing ? 'Following' : 'Follow',
              style: Styles.textStyle14.copyWith(
                color: isFollowing ? Theme.of(context).iconTheme.color : AppColors.iconsColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}