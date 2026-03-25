import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart'; // Assuming this is your ProfileCubit path
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_state.dart';
import 'package:auth/presentation/user/widgets/follow_info_list.dart';
import 'package:auth/presentation/user/widgets/follow_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialInfoScreen extends StatefulWidget {
  final String? userId; // If null, we are looking at "My Profile"
  final int initialTabIndex;

  const SocialInfoScreen({super.key, this.userId, this.initialTabIndex = 0});

  @override
  State<SocialInfoScreen> createState() => _SocialInfoScreenState();
}

class _SocialInfoScreenState extends State<SocialInfoScreen> {
  late String? effectiveUserId;

  @override
  void initState() {
    super.initState();
    effectiveUserId = widget.userId;
    
    // 1. Resolve User ID from ProfileCubit if viewing own profile
    final profileState = context.read<ProfileCubit>().state;
    if (effectiveUserId == null && profileState is ProfileLoaded) {
      effectiveUserId = profileState.user.id;
    }

    // 2. Trigger Initial Data Fetching
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<ProfileSocialInfoCubit>();
      
      // Fetch both lists immediately
      cubit.fetchFollowers(userId: widget.userId);
      cubit.fetchFollowing(userId: widget.userId);
      
      // If it's my profile, fetch requests and suggestions too
      if (widget.userId == null) {
        cubit.fetchRequests();
        cubit.fetchSuggestions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMyProfile = widget.userId == null;
    final int tabCount = isMyProfile ? 4 : 2;
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: tabCount,
      initialIndex: widget.initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Social", style: Styles.textStyle30),
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
              Tab(text: l10n.followers),
              Tab(text: l10n.following),
              if (isMyProfile) ...[
                Tab(text: l10n.requestsTab),
                Tab(text: l10n.suggestionsTab),
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
                    // 1️⃣ Followers List (Crucial: isFollowingList is FALSE)
                    FollowInfoList(
                      data: state.followers,
                      isFollowingList: false, 
                      hasReachedMax: state.hasReachedMaxFollowers,
                      onLoadMore: () => context
                          .read<ProfileSocialInfoCubit>()
                          .fetchFollowers(userId: widget.userId, loadMore: true),
                    ),

                    // 2️⃣ Following List (Crucial: isFollowingList is TRUE)
                    FollowInfoList(
                      data: state.following,
                      isFollowingList: true,
                      hasReachedMax: state.hasReachedMaxFollowing,
                      onLoadMore: () => context
                          .read<ProfileSocialInfoCubit>()
                          .fetchFollowing(userId: widget.userId, loadMore: true),
                    ),

                    // 3️⃣ Requests List
                    if (isMyProfile)
                      _buildRequestsList(context, state.requests),

                    // 4️⃣ Suggestions List
                    if (isMyProfile)
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