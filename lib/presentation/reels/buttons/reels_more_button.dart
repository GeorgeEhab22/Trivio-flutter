import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/home/posts_in_timeline/buttom_sheets/options_bottom_sheet.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReelsMoreButton extends StatelessWidget {
  final Post reel;
  final String currentUserId;

  const ReelsMoreButton({
    super.key,
    required this.reel,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: IconButton(
        onPressed: () {
          final postInteractionCubit = context.read<PostInteractionCubit>();
          final postCubit = context.read<PostCubit>();

          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            useRootNavigator: true,
            builder: (ctx) => Theme(
              data: ThemeData.dark(),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: postInteractionCubit),
                  BlocProvider.value(value: postCubit),
                ],
                child: OptionsBottomSheet(
                  post: reel,
                  currentUserId: currentUserId,
                ),
              ),
            ),
          );
        },
        icon: const Icon(Icons.more_vert, color: Colors.white, size: 26),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }
}
