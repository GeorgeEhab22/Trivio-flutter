import 'package:auth/constants/colors.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_cubit.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowToggleButton extends StatelessWidget {
  final String targetUserId;
  const FollowToggleButton({super.key, required this.targetUserId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FollowCubit, FollowState>(
      listener: (context, state) {
        if (state is FollowFailure) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        final bool isLoading = state is FollowLoading;
        bool isFollowing = false;
        if (state is FollowSuccess) {
          isFollowing = state.follow != null;
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isLoading
                ? Colors.grey
                : (isFollowing ? Colors.green : AppColors.primary),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: InkWell(
            onTap: isLoading
                ? null
                : () {
                    final cubit = context.read<FollowCubit>();

                    if (isFollowing) {
                      // If already following, we want to unfollow
                      //cubit.unfollowUser(targetUserId);

                      // FOR TESTING (Option 2):
                       cubit.debugForceUnfollow();
                    } else {
                      // If not following, we want to follow
                      //cubit.followUser(targetUserId);

                      // FOR TESTING (Option 2):
                       cubit.debugForceSuccess();
                    }
                  },
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      isFollowing ? Icons.check : Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),
            ),
          ),
        );
      },
    );
  }
}
