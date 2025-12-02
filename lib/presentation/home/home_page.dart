import 'package:auth/core/custom_app_bar.dart';
import 'package:auth/presentation/home/add_post/add_post_bottom_sheet.dart';
import 'package:auth/presentation/home/posts_in_timeline/posts_bloc_consumer.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/injection_container.dart' as di;


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PostCubit>()..fetchPosts(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<PostCubit>();
          
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent * 0.9 &&
                          !cubit.isLoadingMore) {
                        cubit.loadMorePosts();
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await cubit.fetchPosts(refresh: true);
                      },
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            floating: true,
                            snap: true,
                            pinned: false,
                            backgroundColor: Colors.white,
                            automaticallyImplyLeading: false,
                            title: const HomeAppBar(),
                          ),
                          
                          const PostsBlocConsumer(),

                          const SliverToBoxAdapter(child: SizedBox(height: 80)),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      backgroundColor: const Color(0xff42C83C),
                      child: const Icon(Icons.add, color: Colors.white),
                      onPressed: () async {
                        final newPost = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const AddPostBottomSheet(),
                        );
                        if (newPost != null && context.mounted) {
                          cubit.addNewPostToFeed(newPost);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}