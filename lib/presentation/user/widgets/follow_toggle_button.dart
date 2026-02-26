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
        
        // 💡 Better Logic: Check if state explicitly tells us we are following
        bool isFollowing = false;
        if (state is FollowSuccess) {
          isFollowing = state.follow != null;
        }

        return GestureDetector( // Using GestureDetector for better hit testing
          onTap: isLoading
              ? null
              : () {
                  final cubit = context.read<FollowCubit>();
                  if (isFollowing) {
                    cubit.debugForceUnfollow();
                  } else {
                    cubit.debugForceSuccess();
                  }
                },
          child: AnimatedContainer(
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
