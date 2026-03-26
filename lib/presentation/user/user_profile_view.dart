import 'package:auth/core/app_routes.dart';
import 'package:auth/core/home_appbar_logo_and_searchbox.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_card.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_posts_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_posts_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/user/widgets/profile_info_box.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileInitial || profileState is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (profileState is ProfileLoaded) {
          final user = profileState.user;
          return BlocBuilder<ProfilePostsCubit, ProfilePostsState>(
            builder: (context, postsState) {
              return Scaffold(
                appBar: AppBar(
                  title: Row(
                    children: [
                      const HomeAppBarLogoAndSearchBox(),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share),
                        tooltip: l10n.shareProfile,
                      ),
                      IconButton(
                        onPressed: () {
                          GoRouter.of(context).push(AppRoutes.profileSettings);
                        },
                        icon: const Icon(Icons.menu),
                        tooltip: l10n.profileSettings,
                      ),
                    ],
                  ),
                  shape: const Border(
                    bottom: BorderSide(color: AppColors.lightGrey, width: 2),
                  ),
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    await context
                        .read<ProfilePostsCubit>()
                        .fetchAllProfileData();
                  },
                  child: CustomScrollView(
                  
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileInfoBox(user: user),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: Styles.textStyle20.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (user.bio?.isNotEmpty ?? false)
                                    Text(
                                      user.bio!,
                                      style: Styles.textStyle16.copyWith(
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  const Divider(color: AppColors.lightGrey),
                                  Text(l10n.posts, style: Styles.textStyle30),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),


                      if (postsState is ProfilePostsLoaded)
                        postsState.myPosts.isEmpty
                            ? SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(child: Text(l10n.noPostsYet)),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  return PostCard(
                                    post: postsState.myPosts[index],
                                    currentUserId: user.id,
                                  );
                                }, childCount: postsState.myPosts.length),
                              )
                      else
                        const SliverToBoxAdapter(child: SizedBox.shrink()),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return const Scaffold(body: SizedBox.shrink());
      },
    );
  }
}
