import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/user/widgets/custom_profile_filled_button.dart';
import 'package:auth/presentation/user/widgets/profile_info_box.dart';
import 'package:auth/presentation/user/widgets/settings_row.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class UserProfileSettings extends StatelessWidget {
  const UserProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Settings", style: Styles.textStyle30),
        shape: Border(bottom: BorderSide(color: AppColors.lightGrey, width: 2)),
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.widthOf(context) * 0.025),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileInfoBox(),
              CustomProfileFilledButton(
                onpressed: () {},
                displayText: "Edit Profile",
                icon: FontAwesomeIcons.userPen,
                color: AppColors.primary,
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGrey, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView(
                  physics:
                      NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SettingsRow(
                      title: "Account Settings",
                      subtitle: "Manage your account details and preferences.",
                      onpressed: () {},
                    ),
                    Divider(color: AppColors.lightGrey),
                    SettingsRow(
                      title: "Privacy Settings",
                      subtitle: "Control who sees your posts and activity.",
                      onpressed: () {},
                    ),
                    Divider(color: AppColors.lightGrey),
                    SettingsRow(
                      title: "Notification Preferences",
                      subtitle: "Customize your notification alerts.",
                      onpressed: () {},
                    ),
                    Divider(color: AppColors.lightGrey),
                    SettingsRow(
                      title: "App Preferences",
                      subtitle: "Adjust language, theme, and data usage",
                      onpressed: () {},
                    ),
                    Divider(color: AppColors.lightGrey),
                    SettingsRow(
                      title: "Require Follow Requests",
                      subtitle: "Manually approve followers",
                      onpressed: () {},
                      isToggle: true,
                    ),
                    Divider(color: AppColors.lightGrey),
                    SettingsRow(
                      title: "Searchable Profile",
                      subtitle:
                          "Allow your profile to appear in search results",
                      onpressed: () {},
                      isToggle: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
