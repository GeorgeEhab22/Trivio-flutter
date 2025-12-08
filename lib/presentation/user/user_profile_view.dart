import 'package:auth/core/app_routes.dart';
import 'package:auth/core/home_appbar_logo_and_searchbox.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/user/widgets/custom_profile_filled_button.dart';
import 'package:auth/presentation/user/widgets/profile_info_box.dart';
import 'package:auth/presentation/user/widgets/profile_social_info.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors.dart';
import 'package:go_router/go_router.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const HomeAppBarLogoAndSearchBox(),
            Spacer(),
            IconButton(
              onPressed: () {
                //share profile
              }, 
            icon: Icon(Icons.share)
            ),

            IconButton(
              onPressed: () {
                GoRouter.of(context).push(AppRoutes.userProfileSettings);
              },
              icon: Icon(Icons.menu),
            ),
          ],
        ),
        shape: Border(bottom: BorderSide(color: AppColors.lightGrey, width: 2)),
      ),
      body: ListView(
        
        children: [
          ProfileInfoBox(),
          SizedBox(height: 10,),
          ProfileSocialInfo(),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CustomProfileFilledButton(
              onpressed: () {
              
              }, 
            displayText: "Follow", 
            icon: Icons.person_add_alt_1_outlined
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Posts",
                style: Styles.textStyle30,
              ),
            ),
            // posts here
          )

        ],
      ),
    );
  }
}
