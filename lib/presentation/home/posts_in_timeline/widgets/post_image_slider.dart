import 'package:auth/constants/colors.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_image.dart';
import 'package:flutter/material.dart';

class PostImageSlider extends StatefulWidget {
  final List<String> images;
  final String postId;

  const PostImageSlider({
    super.key,
    required this.images,
    required this.postId,
  });

  @override
  State<PostImageSlider> createState() => _PostImageSliderState();
}

class _PostImageSliderState extends State<PostImageSlider>
    with AutomaticKeepAliveClientMixin {
  late PageController _pageController;
  late ValueNotifier<int> _currentPageNotifier;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPageNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final maxHeight = MediaQuery.of(context).size.height * 0.55;

    return Column(
      children: [
        const SizedBox(height: 6),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: PageView.builder(
            key: PageStorageKey(widget.postId),
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) => _currentPageNotifier.value = index,
            itemBuilder: (context, index) {
              return PostImage(imageUrl: widget.images[index]);
            },
          ),
        ),

        if (widget.images.length > 1)
          ValueListenableBuilder<int>(
            valueListenable: _currentPageNotifier,
            builder: (context, value, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: _buildCircleIndicator(index == value),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildCircleIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
      width: isActive ? 6 : 4,
      height: isActive ? 6 : 4,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
