import 'package:auth/injection_container.dart' as di;
import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/home/comments/comments_view.dart';
import 'package:auth/presentation/home/share_post/send_post_button.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_state.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/presentation/reels/buttons/reels_comment_button.dart';
import 'package:auth/presentation/reels/buttons/reels_more_button.dart';
import 'package:auth/presentation/reels/buttons/reels_reaction_button.dart';
import 'package:auth/presentation/reels/buttons/reels_share_button.dart';
import 'package:auth/presentation/reels/widgets/reels_buttom_info.dart';
import 'package:auth/presentation/reels/video_play/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:video_player/video_player.dart';

class ReelItem extends StatefulWidget {
  final Post reel;
  final String currentUserId;
  final CachedVideoPlayerPlus? cachedPlayer;
  final int index;

  const ReelItem({
    super.key,
    required this.reel,
    required this.currentUserId,
    this.cachedPlayer,
    required this.index,
  });

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  bool _isCommentsOpen = false;

  void _toggleComments() {
    setState(() => _isCommentsOpen = !_isCommentsOpen);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final commentsHeight = screenHeight * 0.60;

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          top: 0,
          left: 0,
          right: 0,
          bottom: _isCommentsOpen ? commentsHeight : 0,
          child: ClipRRect(
            borderRadius: _isCommentsOpen
                ? const BorderRadius.vertical(bottom: Radius.circular(24))
                : BorderRadius.zero,
            child: Stack(
              fit: StackFit.expand,
              children: [
                VideoPlayerWidget(
                  url: widget.reel.media!.first,
                  cachedPlayer: widget.cachedPlayer,
                ),
                AnimatedOpacity(
                  opacity: _isCommentsOpen ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: _isCommentsOpen,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        IgnorePointer(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black54,
                                  Colors.black87,
                                ],
                                begin: Alignment.center,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        ReelsBottomInfo(
                          reel: widget.reel,
                          currentUserId: widget.currentUserId,
                        ),
                        Positioned(
                          right: 16,
                          bottom: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ReelsReactionButton(
                                reel: widget.reel,
                                currentUserId: widget.currentUserId,
                              ),
                              const SizedBox(height: 6),
                              ReelsCommentButton(
                                reel: widget.reel,
                                currentUserId: widget.currentUserId,
                                onToggleComments: _toggleComments,
                              ),
                              const SizedBox(height: 6),
                              const ReelsShareButton(count: 0),
                              const SizedBox(height: 6),
                              SendPostButton(
                                postId: widget.reel.postID,
                                iconColor: Colors.white,
                                compact: false,
                              ),
                              const SizedBox(height: 14),
                              ReelsMoreButton(
                                reel: widget.reel,
                                currentUserId: widget.currentUserId,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (widget.cachedPlayer != null &&
                    widget.cachedPlayer!.isInitialized &&
                    !_isCommentsOpen)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: VideoProgressIndicator(
                      widget.cachedPlayer!.controller,
                      allowScrubbing: true,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      colors: const VideoProgressColors(
                        playedColor: Colors.white,
                        bufferedColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          left: 0,
          right: 0,
          bottom: _isCommentsOpen ? 0 : -commentsHeight,
          height: commentsHeight,
          child: Theme(
            data: ThemeData.dark(),
            child: BlocProvider(
              create: (context) => di.sl<CommentCubit>(),
              child: BlocListener<CommentCubit, CommentState>(
                listener: (context, state) {
                  if (state is CommentActionSuccess &&
                      state.commentsDelta != 0) {
                    context.read<PostCubit>().incrementCommentsCount(
                      widget.reel.postID,
                      by: state.commentsDelta,
                    );
                  }
                },
                child: CommentsView(
                  postId: widget.reel.postID,
                  currentUserId: widget.currentUserId,
                  isReelView: true,
                ),
              ),
            ),
          ),
        ),

        if (_isCommentsOpen)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: commentsHeight,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _toggleComments,
              child: const SizedBox.expand(),
            ),
          ),
      ],
    );
  }
}
