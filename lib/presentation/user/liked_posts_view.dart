import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_liked_posts_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_liked_posts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikedPostsScreen extends StatelessWidget {
  const LikedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liked Posts", style: Styles.textStyle20),
      ),
      body: BlocBuilder<LikedPostsCubit, LikedPostsState>(
        builder: (context, state) {
          if (state is LikedPostsLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is LikedPostsLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to individual post view
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      image: DecorationImage(
                        image: NetworkImage("https://via.placeholder.com/150"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is LikedPostsError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No liked posts yet."));
        },
      ),
    );
  }
}
