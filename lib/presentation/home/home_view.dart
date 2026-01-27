import 'package:auth/core/custom_app_bar.dart';
import 'package:auth/presentation/home/add_post/add_post_bottom_sheet.dart';
import 'package:auth/presentation/home/posts_in_timeline/time_line_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PostCubit>();

    return BlocListener<PostCubit, PostState>(
      listener: (context, state) {
        if (state is DeletePostSuccess) {
          showCustomSnackBar(context, 'Post deleted successfully', true);
        }
        if (state is DeletePostError) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) =>
                    _handlePagination(scrollInfo, cubit),
                child: RefreshIndicator(
                  onRefresh: () async => await cubit.fetchPosts(refresh: true),
                  child: const CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        floating: true,
                        snap: true,
                        automaticallyImplyLeading: false,
                        title: HomeAppBar(),
                      ),
                      TimelineListView(),
                      SliverToBoxAdapter(child: SizedBox(height: 80)),
                    ],
                  ),
                ),
              ),

              _buildAddPostFAB(context, cubit),
            ],
          ),
        ),
      ),
    );
  }
}

bool _handlePagination(ScrollNotification scrollInfo, PostCubit cubit) {
  if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.9 &&
      !cubit.isLoadingMore) {
    cubit.loadMorePosts();
  }
  return false;
}

Widget _buildAddPostFAB(BuildContext context, PostCubit cubit) {
  return Positioned(
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
  );
}
