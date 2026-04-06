import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_state.dart';
import 'package:auth/presentation/notifcations/widgets/notifications_tab_bar.dart';
import 'package:auth/presentation/user/widgets/follow_info_list.dart';
import 'package:auth/presentation/user/widgets/follow_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SocialInfoScreen extends StatelessWidget {
  final String? userId; // If null, we are looking at "My Profile"
  final int initialTabIndex;

  const SocialInfoScreen({super.key, this.userId, this.initialTabIndex = 0});

  @override
  Widget build(BuildContext context) {
    final bool isMyProfile = userId == null;

    final bool isPrivateAccount =
        context.read<ProfileCubit>().user?.privacy ?? false;

    final int tabCount = (isMyProfile && isPrivateAccount) ? 3 : 2;

    final l10n = AppLocalizations.of(context)!;
    final List<String> tabTitles = (isMyProfile && isPrivateAccount)
        ? [
            l10n.followers,
            l10n.following,
            l10n.requestsTab /*l10n.suggestionsTab*/,
          ]
        : [l10n.followers, l10n.following];

    _onWidgetBuilt(context,isPrivateAccount);

    return DefaultTabController(
      length: tabCount,
      initialIndex: initialTabIndex,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text("Social", style: Styles.textStyle25),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).iconTheme.color,
                  size: 25,
                ),
              ),
             bottom: PreferredSize(
                preferredSize: const Size.fromHeight(65),
                child: AnimatedBuilder(
                  animation: tabController,
                  builder: (context, _) {
                    return Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: NotificationsTabBar(
                          tabs: tabTitles,
                          selectedIndex: tabController.index,
                          onTabChanged: (index) {
                            tabController.animateTo(index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            body: BlocListener<ProfileSocialInfoCubit, ProfileSocialInfoState>(
              listener: (context, state) {
                if (state is SocialActionSuccess) {
                  showCustomSnackBar(context, state.message, true);
                }
                if (state is SocialInfoFailure) {
                  showCustomSnackBar(context, state.message, false);
                }
              },
              child:
                  BlocBuilder<ProfileSocialInfoCubit, ProfileSocialInfoState>(
                    builder: (context, state) {
                      if (state is SocialInfoLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }

                      if (state is SocialInfoLoaded) {
                        return TabBarView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            // Followers List
                            FollowInfoList(
                              data: state.followers,
                              isFollowingList: false,
                              hasReachedMax: state.hasReachedMaxFollowers,
                              onLoadMore: () => context
                                  .read<ProfileSocialInfoCubit>()
                                  .fetchFollowers(
                                    userId: userId,
                                    loadMore: true,
                                  ),
                            ),

                            // Following List
                            FollowInfoList(
                              data: state.following,
                              isFollowingList: true,
                              hasReachedMax: state.hasReachedMaxFollowing,
                              onLoadMore: () => context
                                  .read<ProfileSocialInfoCubit>()
                                  .fetchFollowing(
                                    userId: userId,
                                    loadMore: true,
                                  ),
                            ),

                            // Requests List
                            if (isMyProfile && isPrivateAccount)
                              _buildRequestsList(context, state.requests),

                            // Suggestions List
                            // if (isMyProfile)
                            //   FollowInfoList(
                            //     data: state.suggestions,
                            //     hasReachedMax: true,
                            //   ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
            ),
          );
        },
      ),
    );
  }

  void _onWidgetBuilt(BuildContext context, bool isPrivateAccount) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<ProfileSocialInfoCubit>();

      cubit.fetchFollowers(userId: userId);
      cubit.fetchFollowing(userId: userId);

      if (userId == null) {
        if (isPrivateAccount) {
           cubit.fetchRequests();
        }
        // cubit.fetchSuggestions();
      }
    });
  }

  Widget _buildRequestsList(BuildContext context, List requests) {
    final l10n = AppLocalizations.of(context)!;
    if (requests.isEmpty) {
      return Center(
        child: Text(
          l10n.noPendingRequestsSimple,
          style: Styles.textStyle20.copyWith(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return FollowRequestCard(
          key: ValueKey(request.id),
          follower: request.follower,
          onAccept: () =>
              context.read<ProfileSocialInfoCubit>().acceptRequest(request.id),
          onDecline: () =>
              context.read<ProfileSocialInfoCubit>().declineRequest(request.id),
        );
      },
    );
  }
}
