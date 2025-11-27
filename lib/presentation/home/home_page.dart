import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/home/add_post/add_post_bottom_sheet.dart';
import 'package:auth/core/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'posts_in_timeline/post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  final posts = [
    {
      'id': '1',
      'authorId': '101',
      'authorName': 'Marcus Rashford',
      'authorImage': 'assets/images/player1.png',
      'content':
          "Thrilled with the team's performance today! The energy on the pitch was electric. Great win, and a huge thank you to the fans for their incredible support! ⚽ #ManUtd #FootballIsLife",
      'imageUrl': 'assets/images/post1.png',
      'createdAt': DateTime.now()
          .subtract(const Duration(hours: 2))
          .toIso8601String(),
    },
    {
      'id': '2',
      'authorId': '102',
      'authorName': 'LionessPride Official',
      'authorImage': 'assets/images/player2.png',
      'content':
          "What a spectacular match last night! The determination and skill shown by our squad were truly inspiring. Onwards and upwards! 💪 #WomensFootball",
      'imageUrl': 'assets/images/post2.png',
      'createdAt': DateTime.now()
          .subtract(const Duration(hours: 5))
          .toIso8601String(),
    },
    {
      'id': '3',
      'authorId': '103',
      'authorName': 'Marcus Rashford',
      'authorImage': 'assets/images/player1.png',
      'content':
          "Thrilled with the team's performance today! The energy on the pitch was electric. Great win, and a huge thank you to the fans for their incredible support! ⚽ #ManUtd #FootballIsLife",
      'imageUrl': 'assets/images/post1.png',
      'createdAt': DateTime.now()
          .subtract(const Duration(hours: 8))
          .toIso8601String(),
    },
    {
      'id': '4',
      'authorId': '104',
      'authorName': 'Marcus Rashford',
      'authorImage': 'assets/images/player1.png',
      'content':
          "Thrilled with the team's performance today! The energy on the pitch was electric. Great win, and a huge thank you to the fans for their incredible support! ⚽ #ManUtd #FootballIsLife",
      'imageUrl': 'assets/images/post1.png',
      'createdAt': DateTime.now()
          .subtract(const Duration(hours: 8))
          .toIso8601String(),
    },{
      'id': '5',
      'authorId': '105',
      'authorName': 'Marcus Rashford',
      'authorImage': 'assets/images/player1.png',
      'content':
          "Thrilled with the team's performance today! The energy on the pitch was electric. Great win, and a huge thank you to the fans for their incredible support! ⚽ #ManUtd #FootballIsLife",
      'imageUrl': 'assets/images/post1.png',
      'createdAt': DateTime.now()
          .subtract(const Duration(hours: 8))
          .toIso8601String(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          /// ---------- MAIN CONTENT ---------- 
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                pinned: false,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: const HomeAppBar(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final postMap = posts[index];
                    final postEntity = Post(
                      id: postMap['id'] ?? '',
                      authorId: postMap['authorId'] ?? '',
                      authorName: postMap['authorName'] ?? '',
                      authorImage: postMap['authorImage'] ?? '',
                      content: postMap['content'] ?? '',
                      imageUrl: postMap['imageUrl'] ?? '',
                      createdAt: DateTime.parse(
                          postMap['createdAt'] ?? DateTime.now().toIso8601String()),
                    );
                    return PostCard(post: postEntity);
                  },
                  childCount: posts.length,
                ),
              ),
            ],
          ),

          /// ---------- FAB ---------- 
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: const Color(0xff42C83C),
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const AddPostBottomSheet(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
