import 'package:auth/presentation/home/add_post/add_post_buttom_sheet.dart';
import 'package:auth/presentation/home/app_bar/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'navigation/custom_button_nav_bar.dart';
import 'posts_in_timeline/post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // stores the current index of the bottom navigation bar
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // ✅ TODO :
    // Call fetchPostsUseCase() through your state management layer (Cubit/Provider).
    //
    // Example for later:
    // context.read<PostsCubit>().fetchPosts();
  }

  final posts = [
    {
      'author': 'Marcus Rashford',
      'authorImage': 'assets/images/player1.png',
      'timeAgo': '2 hours ago',
      'content':
          "Thrilled with the team's performance today! The energy on the pitch was electric. Great win, and a huge thank you to the fans for their incredible support! ⚽ #ManUtd #FootballIsLife",
      'imageUrl': 'assets/images/post1.png',
      'likes': 999,
      'comments': 870,
      'shares': 999,
    },
    {
      'author': 'LionessPride Official',
      'authorImage': 'assets/images/player2.png',
      'timeAgo': '5 hours ago',
      'content':
          "What a spectacular match last night! The determination and skill shown by our squad were truly inspiring. Onwards and upwards! 💪 #WomensFootball",
      'imageUrl': 'assets/images/post2.png',
      'likes': 7800,
      'comments': 5100000,
      'shares': 180,
    },
    {
      'author': 'Marcus Rashford',
      'authorImage': 'assets/images/player1.png',
      'timeAgo': '2 hours ago',
      'content':
          "Thrilled with the team's performance today! The energy on the pitch was electric. Great win, and a huge thank you to the fans for their incredible support! ⚽ #ManUtd #FootballIsLife",
      'imageUrl': 'assets/images/post1.png',
      'likes': 1250,
      'comments': 870,
      'shares': 320,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: const HomeAppBar(),
      body: SafeArea(
        top: false,
        child: ListView.builder(
          // ✅ TODO:
          // Later, replace this static list with state from Cubit/Provider.
          // Example:
          //
          // BlocBuilder<PostsCubit, PostsState>(
          //   builder: (context, state) {
          //     if (state is PostsLoading) return CircularProgressIndicator();
          //     if (state is PostsLoaded) return ListView.builder(...);
          //   },
          // );
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index] as Map<String, dynamic>;
            return PostCard(
              author: post['author']!,
              authorImage: post['authorImage'],
              timeAgo: post['timeAgo']!,
              content: post['content']!,
              imageUrl: post['imageUrl'],
              likes: post['likes']!,
              comments: post['comments']!,
              shares: post['shares']!,
              isFollowing: true,
              isSaved: false,
            );
          },
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xff42C83C),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // ✅ TODO:
          // Open AddPostBottomSheet and after the user submits,
          // call createPostUseCase() through your state management layer.
          //
          // Example for later:
          // context.read<CreatePostCubit>().createPost(data);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddPostBottomSheet(
              // TODO:
              // Add a callback here when you implement create post:
              //
              // onSubmit: (postData) {
              //   context.read<CreatePostCubit>().createPost(postData);
              // }
            ),
          );
        },
      ),
    );
  }
}
