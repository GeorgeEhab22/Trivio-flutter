import 'package:auth/presentation/home/posts_in_timeline/widgets/post_card.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/presentation/manager/profile_cubit/saved_posts/saved_posts_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/saved_posts/saved_posts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/l10n/app_localizations.dart';

class SavedPostsView extends StatefulWidget {
  const SavedPostsView({super.key});

  @override
  State<SavedPostsView> createState() => _SavedPostsViewState();
}

class _SavedPostsViewState extends State<SavedPostsView> {
  @override
  void initState() {
    super.initState();
    // Load the posts when the screen is first opened
    context.read<SavedPostsCubit>().loadSavedPosts();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          l10n.savedPosts,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        // 1. Back Button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<SavedPostsCubit, SavedPostsState>(
        builder: (context, state) {
          // 3. Loading State
          if (state is SavedPostsLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
              final profileState = context.read<ProfileCubit>().state;
    String myUserId = ''; 
    
    if (profileState is ProfileLoaded) {
      myUserId = profileState.user.id; 
    }
          // 3. Error State
          if (state is SavedPostsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  TextButton(
                    onPressed: () => context.read<SavedPostsCubit>().loadSavedPosts(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          // 3. Success State (with Empty check)
          if (state is SavedPostsLoaded) {
            final posts = state.savedPosts;

            if (posts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border_rounded,
                      size: 64,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noSavedPosts,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(post: post, currentUserId: myUserId);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}