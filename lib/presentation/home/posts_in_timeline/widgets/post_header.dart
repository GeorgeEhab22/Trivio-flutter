import 'package:auth/presentation/home/posts_in_timeline/widgets/follow_button.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/home/widgets/author_info.dart';
import 'package:auth/presentation/home/posts_in_timeline/buttom_sheets/options_bottom_sheet.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';

class PostHeader extends StatelessWidget {
  final Post post;
  final String currentUserId;
  final bool isFollowing;

  const PostHeader({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    final bool isGroupPost = post.location == "group";
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconBgColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.04);
    final Color iconBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.08);
  
    //TODO: change with actual users when backend return the name and the image of author
    String authorName = "Not Me";
    String? authorImage;

    final profileState = context.read<ProfileCubit>().state;

    if (profileState is ProfileLoaded &&
        post.authorId == profileState.user.id) {
      authorName = profileState.user.name;
      authorImage = profileState.user.avatar;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AuthorInfo(
              authorName: authorName,
              authorImage: authorImage,
              createdAt: post.createdAt,
              showTimeInline: false,
              isGroupPost: isGroupPost,
              groupImage: post.groupCoverImage,
              groupName: post.groupName,
              avatarRadius: 20,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isGroupPost) ...[
                if (post.authorId != currentUserId)
                  FollowButton(
                    currentUserId: currentUserId,
                    authorId: post.authorId,
                    initialFollowStatus: isFollowing,
                  ),
              ],
              SizedBox(width: 8),
              Container(
                width: 34,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: iconBgColor,
                  border: Border.all(color: iconBorderColor),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    final postInteractionCubit = context
                        .read<PostInteractionCubit>();
                    final postCubit = context.read<PostCubit>();
                    GroupPostsCubit? groupPostsCubit;
                    try {
                      groupPostsCubit = context.read<GroupPostsCubit>();
                    } catch (_) {}

                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      useRootNavigator: true,
                      builder: (ctx) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: postInteractionCubit),
                          BlocProvider.value(value: postCubit),
                          if (groupPostsCubit != null)
                            BlocProvider.value(value: groupPostsCubit),
                        ],
                        child: OptionsBottomSheet(
                          post: post,
                          currentUserId: currentUserId,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
