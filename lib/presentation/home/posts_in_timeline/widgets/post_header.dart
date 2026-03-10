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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isGroupPost) ...[
                if (post.authorId != currentUserId)
                  FollowButton(
                    currentUserId: currentUserId,
                    authorId: post.authorId??'',
                    initialFollowStatus: isFollowing,
                  ),
              ],
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  final postInteractionCubit = context
                      .read<PostInteractionCubit>();
                  final postCubit = context.read<PostCubit>();
                  GroupPostsCubit? groupPostCubit;
                  if (isGroupPost) {
                    groupPostCubit = context.read<GroupPostsCubit>();
                  }
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    useRootNavigator: true,
                    builder: (ctx) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: postInteractionCubit),
                        BlocProvider.value(value: postCubit),
                        if (groupPostCubit != null)
                          BlocProvider.value(value: groupPostCubit),
                      ],
                      child: OptionsBottomSheet(
                        post: post,
                        currentUserId: currentUserId,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
