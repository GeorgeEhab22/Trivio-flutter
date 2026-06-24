import 'package:auth/injection_container.dart' as di;
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/shared_post_preview.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/get_post/get_post_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/get_post/get_post_state.dart'; // Ensure this is imported
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../common/basic_app_button.dart';

class ShareBottomSheet extends StatefulWidget {
  final Post post;
  const ShareBottomSheet({super.key, required this.post});

  @override
  State<ShareBottomSheet> createState() => _ShareBottomSheetState();
}

class _ShareBottomSheetState extends State<ShareBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<GetPostCubit>().getPost(widget.post.postID);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSharePressed() {
    context.read<PostInteractionCubit>().sharePost(
      postId: widget.post.postID,
      type: 'public',
      caption: _controller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = context.watch<ProfileCubit>().state;
    String? currentUserAvatar;
    String currentUserName = l10n.defaultUserName;

    if (profileState is ProfileLoaded) {
      currentUserAvatar = profileState.user.avatar;
      currentUserName = profileState.user.name;
    }
    return MultiBlocListener(
      listeners: [
        BlocListener<PostInteractionCubit, PostInteractionState>(
          listenWhen: (prev, curr) =>
              (curr is SharePostSuccess) ||
              (curr is SharePostError && curr.postId == widget.post.postID),
          listener: (context, state) {
            if (state is SharePostSuccess) {
              showCustomSnackBar(context, l10n.shareSuccess, true);
              context.pop();
            } else if (state is SharePostError) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
      ],
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            currentUserAvatar != null &&
                                currentUserAvatar.isNotEmpty
                            ? NetworkImage(currentUserAvatar)
                            : null,
                        child:
                            currentUserAvatar == null ||
                                currentUserAvatar.isEmpty
                            ? const Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 10),

                      Text(
                        currentUserName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const Spacer(),
                      BlocBuilder<PostInteractionCubit, PostInteractionState>(
                        builder: (context, state) {
                          final isLoading =
                              state is SharePostLoading &&
                              state.postId == widget.post.postID;
                          return BasicAppButton(
                            onPressed: isLoading ? null : _onSharePressed,
                            title: isLoading ? "..." : l10n.shareAction,
                            height: 36,
                            width: 90,
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _controller,
                    maxLines: 2,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: l10n.shareHint,
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
                    child: BlocBuilder<GetPostCubit, GetPostState>(
                      builder: (context, state) {
                        if (state is GetPostLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        } else if (state is GetPostSuccess) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.3,
                            ),
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: BlocProvider(
                                create: (context) => di.sl<FollowCubit>(),
                                child: SharedPostPreview(post: state.post),
                              ),
                            ),
                          );
                        } else if (state is GetPostFailure) {
                          return Text(
                            state.message,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
