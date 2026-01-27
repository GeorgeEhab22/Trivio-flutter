import 'package:auth/presentation/home/posts_in_timeline/widgets/follow_button.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AuthorInfo(
              authorName:"messi",
              showTimeInline: false,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FollowButton(
                currentUserId: currentUserId,
                authorId: post.authorId ?? '',
                initialFollowStatus: isFollowing,
              ),
              
              IconButton(
                icon: Icon(Icons.more_vert, color: Theme.of(context).iconTheme.color),
                onPressed: () {
                  final postInteractionCubit = context.read<PostInteractionCubit>();
                  final postCubit = context.read<PostCubit>();
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    useRootNavigator: true,
                    builder: (ctx) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: postInteractionCubit),
                        BlocProvider.value(value: postCubit),
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