import 'package:auth/constants/colors.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_cubit.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';

class FollowButton extends StatefulWidget {
  final String currentUserId;
  final String authorId;
  final bool isFollowing; 
  final bool isReel;
  final String? followedText;
  final String? unfollowedText;
  final VoidCallback? onFollowChanged;
  const FollowButton({
    super.key,
    required this.currentUserId,
    required this.authorId,
    required this.isFollowing,
    this.isReel = false,
    this.followedText,
    this.unfollowedText,
    this.onFollowChanged,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  late bool _isFollowing;
  bool _isProcessingLocally = false;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.isFollowing;
  }

  @override
  void didUpdateWidget(covariant FollowButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFollowing != widget.isFollowing) {
      _isFollowing = widget.isFollowing;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentUserId == widget.authorId) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    
    String buttonText;
    if (_isFollowing) {
      buttonText = widget.followedText ?? l10n.following;
    } else {
      buttonText = widget.unfollowedText ?? l10n.follow;
    }

    return BlocListener<FollowCubit, FollowState>(
      listener: (context, state) {
        if (_isProcessingLocally && state is FollowFailure) {
          showCustomSnackBar(context, state.message, false);
          setState(() {
            _isFollowing = !_isFollowing;
            _isProcessingLocally = false;
          });
        } 
        if (state is FollowSuccess && state.follow?.user.id == widget.authorId) {
          setState(() {
            _isFollowing = true;
            _isProcessingLocally = false;
            widget.onFollowChanged?.call();
          });
        } else if (state is UnfollowSuccess && state.unfollowedUserId == widget.authorId) {
          setState(() {
            _isFollowing = false;
            _isProcessingLocally = false;
          });
          widget.onFollowChanged?.call();
        }
      },
      child: SizedBox(
        height: 30,
        child: TextButton(
          onPressed: _isProcessingLocally
              ? null
              : () {
                  setState(() {
                    _isProcessingLocally = true;
                    _isFollowing = !_isFollowing;
                  });

                  if (_isFollowing) {
                    context.read<FollowCubit>().followUser(widget.authorId);
                  } else {
                    context.read<FollowCubit>().unfollowUser(widget.authorId);
                  }
                  
                },
          style: TextButton.styleFrom(
            backgroundColor: widget.isReel
                ? Colors.transparent
                : (_isFollowing
                    ? Colors.transparent
                    : Theme.of(context).cardColor),
            side: widget.isReel
                ? BorderSide(color: AppColors.primary, width: 1.2)
                : (_isFollowing
                    ? BorderSide(
                        color: Theme.of(context).iconTheme.color!,
                      )
                    : BorderSide.none),
            padding: EdgeInsets.symmetric(
              horizontal: _isFollowing ? 18 : 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: _isProcessingLocally
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  buttonText,
                  style: Styles.textStyle14.copyWith(
                    color: widget.isReel
                        ? Colors.white
                        : (_isFollowing
                            ? Theme.of(context).iconTheme.color
                            : Theme.of(context).textTheme.bodyMedium?.color),
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}