import 'package:auth/constants/colors';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 0.8),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onTap,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.iconsColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house, size: 26),
            activeIcon: Icon(FontAwesomeIcons.solidHouse, size: 26),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.play, size: 26),
            activeIcon: Icon(Icons.play_circle_filled, size: 26),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined, size: 26),
            activeIcon: Icon(Icons.smart_toy, size: 26),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userGroup, size: 26),
            activeIcon: FaIcon(FontAwesomeIcons.users, size: 26),

            label: 'Following',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartColumn, size: 26),
            activeIcon: Icon(FontAwesomeIcons.solidChartBar, size: 26),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}
