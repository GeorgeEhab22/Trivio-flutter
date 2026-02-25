import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_state.dart';
import 'package:auth/presentation/user/widgets/follow_info_list.dart';
import 'package:auth/presentation/user/widgets/follow_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ... (Your imports remain the same)

class SocialInfoScreen extends StatelessWidget {
  final String? userId;
  final int initialTabIndex;

  const SocialInfoScreen({super.key, this.userId, this.initialTabIndex = 0});

  @override
  Widget build(BuildContext context) {
    final bool isMyProfile = userId == null;
    final int tabCount = isMyProfile ? 4 : 2;

    // Trigger initial fetches - typically done in a post-frame callback or initState,
    // but works here for a quick refresh.
    final cubit = context.read<ProfileSocialInfoCubit>();
    cubit.fetchFollowers(userId: userId);
    cubit.fetchFollowing(userId: userId);
    if (isMyProfile) {
      cubit.fetchRequests();
      cubit.fetchSuggestions();
    }

    return DefaultTabController(
      length: tabCount,
      initialIndex: initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Follow Info", style: Styles.textStyle30),
          centerTitle: true,
          shape: const Border(
            bottom: BorderSide(color: AppColors.lightGrey, width: 2),
          ),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            tabs: [
              const Tab(text: "Followers"),
              const Tab(text: "Following"),
              if (isMyProfile) ...[
                const Tab(text: "Requests"),
                const Tab(text: "Suggestions"),
              ],
            ],
          ),
        ),
        body: BlocListener<ProfileSocialInfoCubit, ProfileSocialInfoState>(
          listener: (context, state) {
            if (state is SocialActionSuccess) {
              showCustomSnackBar(context, state.message, true);
            }
            if (state is SocialInfoFailure) {
              print("🔴 SocialInfo Screen Error: ${state.message}");
              showCustomSnackBar(context, state.message, false);
            }
          },
          child: BlocBuilder<ProfileSocialInfoCubit, ProfileSocialInfoState>(
            builder: (context, state) {
              if (state is SocialInfoLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is SocialInfoLoaded) {
                return TabBarView(
                  children: [
                    // 1️⃣ Followers List
                    FollowInfoList(
                      data: state.followers,
                      isFollowingList: false,
                      hasReachedMax: state.hasReachedMaxFollowers,
                      onLoadMore: () =>
                          cubit.fetchFollowers(userId: userId, loadMore: true),
                    ),

                    // 2️⃣ Following List
                    FollowInfoList(
                      data: state.following,
                      isFollowingList: true,
                      hasReachedMax: state.hasReachedMaxFollowing,
                      onLoadMore: () =>
                          cubit.fetchFollowing(userId: userId, loadMore: true),
                    ),

                    // 3️⃣ Requests List (Only if it's "My" profile)
                    if (isMyProfile)
                      _buildRequestsList(context, state.requests),
                    FollowInfoList(
                      data: state.suggestions,
                      hasReachedMax: true,
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  // Implementation of the Requests tab
  Widget _buildRequestsList(BuildContext context, List requests) {
    if (requests.isEmpty) {
      return Center(
        child: Text(
          "No pending requests",
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
          onAccept: () {
            context.read<ProfileSocialInfoCubit>().acceptRequest(request.id);
          },
          onDecline: () {
            context.read<ProfileSocialInfoCubit>().declineRequest(request.id);
          },
        );
      },
    );
  }
}
