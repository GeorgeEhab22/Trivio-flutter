
import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/user/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("My Profile", style: Styles.textStyle30)),
        shape: Border(
          bottom: BorderSide(color: AppColors.lightGrey, width: 2),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.widthOf(context) * 0.025),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            profileInfoBox(context),
            SizedBox(height: 30),
            profileSocialInfo(),
            SizedBox(height: 30),
            customProfileFilledButton(
              () {},
              "Edit Profile",
              FontAwesomeIcons.userPen,
              color: AppColors.primary,
            ),
            SizedBox(height: 10),
            customProfileFilledButton(
              () {},
              "Share Profile",
              Icons.share_outlined,
            ),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.lightGrey, 
                    width: 2, 
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    settingsRow(title: "Account Settings", subtitle: "Manage your account details and preferences.", onpressed: (){}),
                    Divider(color: AppColors.lightGrey),
                    settingsRow(title: "Privacy Settings", subtitle: "Control who sees your posts and activity.", onpressed: (){}),
                    Divider(color: AppColors.lightGrey),
                    settingsRow(title: "Notification Preferences", subtitle: "Customize your notification alerts.", onpressed: (){}),
                    Divider(color: AppColors.lightGrey),
                    settingsRow(title: "App Preferences", subtitle: "Adjust language, theme, and data usage", onpressed: (){}),
                    Divider(color: AppColors.lightGrey),
                    settingsRow(title: "Require Foloow Requests", subtitle: "Manually approve followers", onpressed: (){}, isToggle: true),
                    Divider(color: AppColors.lightGrey),
                    settingsRow(title: "Searchable Profile", subtitle: "Allow your profile to appear in search results", onpressed: (){}, isToggle: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

