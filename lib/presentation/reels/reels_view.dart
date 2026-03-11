import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/presentation/reels/widgets/reels_app_bar.dart';
import 'package:auth/presentation/reels/buttons/reels_comment_button.dart';
import 'package:auth/presentation/reels/buttons/reels_more_button.dart';
import 'package:auth/presentation/reels/buttons/reels_reaction_button.dart';
import 'package:auth/presentation/reels/buttons/reels_save_button.dart';
import 'package:auth/presentation/reels/buttons/reels_share_button.dart';
import 'package:auth/presentation/reels/widgets/reels_buttom_info.dart';
import 'package:auth/presentation/reels/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReelsView extends StatelessWidget {
  const ReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = context.read<ProfileCubit>().state;
    final String currentUserId = profileState is ProfileLoaded
        ? profileState.user.id
        : "";

    return Scaffold(
      backgroundColor: Colors.black,
      //TODO : create reel cubit and replace post cubit , remove ang post logic later
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (state is PostLoaded) {
            final reels = state.posts
                .where((p) => p.media != null && p.media!.isNotEmpty)
                .toList();

            if (reels.isEmpty) {
              return const Center(
                child: Text(
                  "No Reels yet",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: reels.length,
              itemBuilder: (context, index) {
                //TODO : using this filter of posts and access reels from posts untill the endponit finished
                final reels = state.posts.where((p) {
                  if (p.media == null || p.media!.isEmpty) return false;

                  final String firstMedia = p.media!.first.toLowerCase();
                  return firstMedia.endsWith('.mp4') ||
                      firstMedia.endsWith('.mov') ||
                      firstMedia.endsWith('.webm');
                }).toList();

                final reel = reels[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    VideoPlayerWidget(url: reel.media!.first),

                    IgnorePointer(child: _buildBottomGradient()),

                    ReelsBottomInfo(reel: reel, currentUserId: currentUserId),

                    Positioned(
                      right: 16,
                      bottom: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ReelsReactionButton(
                            postId: reel.postID,
                            currentUserId: currentUserId,
                          ),
                          const SizedBox(height: 16),
                          ReelsCommentButton(
                            count: reel.commentsCount.toString(),
                            onTap: () {
                              //TODO : ADD Comments sheeet
                            },
                          ),
                          const SizedBox(height: 16),
                          ReelsShareButton(count: 'Share', onTap: () {}),
                          const SizedBox(height: 16),
                          ReelsSaveButton(count: 'Save', onTap: () {}),
                          const SizedBox(height: 16),
                          ReelsMoreButton(onTap: () {}),
                        ],
                      ),
                    ),

                    const ReelsAppBar(),
                  ],
                );
              },
            );
          } else if (state is PostError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBottomGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black54, Colors.black87],
          begin: Alignment.center,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
