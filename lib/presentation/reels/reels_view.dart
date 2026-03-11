import 'package:auth/presentation/reels/widgets/reels_app_bar.dart';
import 'package:auth/presentation/reels/buttons/reels_buttom_info.dart';
import 'package:auth/presentation/reels/buttons/reels_comment_button.dart';
import 'package:auth/presentation/reels/buttons/reels_more_button.dart';
import 'package:auth/presentation/reels/buttons/reels_reaction_button.dart';
import 'package:auth/presentation/reels/buttons/reels_save_button.dart';
import 'package:auth/presentation/reels/buttons/reels_send_button.dart';
import 'package:auth/presentation/reels/buttons/reels_share_button.dart';
import 'package:flutter/material.dart';

class ReelsView extends StatelessWidget {
  const ReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: const Color.fromARGB(255, 30, 30, 30),
                child: const Center(
                  child: Icon(
                    Icons.play_arrow,
                    size: 100,
                    color: Colors.white10,
                  ),
                ),
              ),

              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black87],
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    stops: [0.4, 1.0],
                  ),
                ),
              ),

              const ReelsBottomInfo(),

              Positioned(
                right: 16,
                bottom: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ReelsReactionButton(postId: "123", currentUserId: "user_1"),
                    ReelsCommentButton(
                      count: '345',
                      onTap: () {
                    
                      },
                    ),
                    ReelsShareButton(count: '50K', onTap: () {}),
                    ReelsSendButton(count: '100', onTap: () {}),
                    ReelsSaveButton(count: '45', onTap: () {}),
                    ReelsMoreButton(onTap: () {}),
                  ],
                ),
              ),

              const ReelsAppBar(),
            ],
          );
        },
      ),
    );
  }
}
