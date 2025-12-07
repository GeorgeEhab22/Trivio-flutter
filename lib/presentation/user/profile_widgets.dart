import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

//can be used later for follow/report when opening another user profile
Widget customProfileFilledButton(
  VoidCallback onpressed,
  String displayText,
  IconData icon, {
  Color? color,
}) {
  var iconAndTextColor = color != null ? Colors.white : Colors.black;
  return FilledButton(
    onPressed: onpressed,
    style: ButtonStyle(
      backgroundColor: color != null
          ? WidgetStatePropertyAll(color)
          : WidgetStatePropertyAll(Colors.transparent),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: color == null
              ? BorderSide(color: AppColors.lightGrey, width: 2)
              : BorderSide.none,
        ),
      ),
      fixedSize: WidgetStatePropertyAll(Size(double.infinity, 40)),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconAndTextColor),
          SizedBox(width: 8),
          Text(
            displayText,
            style: Styles.textStyle14.copyWith(color: iconAndTextColor),
          ),
        ],
      ),
    ),
  );
}

Widget customColumnForProfileInfo(String number, String thing) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            number,
            style: Styles.textStyle20.copyWith(color: AppColors.primary),
          ),
          Text(thing),
        ],
      ),
    ),
  );
}

Widget profileInfoBox(
  BuildContext context, {
  String username = "Username",
  String userAt = "@User",
  String userAbout = "About",
  String? avatarUrl, // optional avatar URL or file path
}) {
  return Container(
    decoration: BoxDecoration(
      //border: Border.all(color: AppColors.lightGrey, width: 2),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.15,
              height: MediaQuery.sizeOf(context).width * 0.15,
              child: CircleAvatar(
                backgroundColor: Colors.black,
                backgroundImage:
                    avatarUrl != null && avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : null, // use image if provided
                child: (avatarUrl == null || avatarUrl.isEmpty)
                    ? Text(
                        username[0].toUpperCase(),
                        style: Styles.textStyle25.copyWith(
                          color: Colors.white,
                        ),
                      )
                    : null, // show first letter if no image
              ),
            ),
            const SizedBox(height: 10),
            Text(username, style: Styles.textStyle25),
            Text(userAt, style: Styles.textStyle16),
            const SizedBox(height: 5),
            Text(userAbout, style: Styles.textStyle14),
            const SizedBox(height: 5),
          ],
        ),
      ),
    ),
  );
}


Widget profileSocialInfo({
  int numberOfFollowers = 0,
  int numberOfFollowing = 0,
  int numberOfPosts = 0,
}) {
  return Container(
    
    decoration: BoxDecoration(
      //border: Border.all(color: AppColors.lightGrey, width: 2),

      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          customColumnForProfileInfo(numberOfFollowers.toString(), "followers"),
          customColumnForProfileInfo(numberOfFollowing.toString(), "following"),
          customColumnForProfileInfo(numberOfPosts.toString(), "posts"),
        ],
      ),
    ),
  );
}

Widget settingsRow({
  required String title,
  required String subtitle,
  required VoidCallback onpressed,
  bool isToggle = false, // false means next, true means toggle
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
    child: Row(
      children: [
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Styles.textStyle18),
              SizedBox(height: 5),
              Text(
                subtitle,
                style: Styles.textStyle16.copyWith(color: AppColors.darkGrey),
                softWrap: true,
              ),
            ],
          ),
        ),
        !isToggle
            ? IconButton(
                onPressed: onpressed,
                icon: Icon(Icons.keyboard_arrow_right),
                highlightColor: AppColors.primary,
                padding: EdgeInsets.zero,
              )
            : _ToggleSwitch(), // move switch into its own Stateful widget so only it is rebuilt
      ],
    ),
  );
}

// Separate Stateful widget for the switch so only it gets rebuilt
class _ToggleSwitch extends StatefulWidget {
  @override
  State<_ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<_ToggleSwitch> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeThumbColor: AppColors.primary,
      value: isSwitched,
      onChanged: (value) {
        setState(() {
          isSwitched = value;
        });
      },
    );
  }
}