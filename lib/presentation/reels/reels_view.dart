import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/presentation/reels/widgets/reel_item.dart';
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
                final reelsFiltered = state.posts.where((p) {
                  if (p.media == null || p.media!.isEmpty) return false;

                  final String firstMedia = p.media!.first.toLowerCase();
                  return firstMedia.endsWith('.mp4') ||
                      firstMedia.endsWith('.mov') ||
                      firstMedia.endsWith('.webm');
                }).toList();

                if (index >= reelsFiltered.length) return const SizedBox();

                final reel = reelsFiltered[index];

                return ReelItem(reel: reel, currentUserId: currentUserId);
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
}
