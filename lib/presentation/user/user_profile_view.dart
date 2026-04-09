import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_card.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/get_user_profile_by_id_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/get_user_profile_by_id_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_posts_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_posts_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/profile_cubit/user/get_user_posts_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/user/get_user_posts_state.dart';
import 'package:auth/presentation/user/widgets/profile_info_box.dart';
import 'package:auth/presentation/user/widgets/profile_social_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';

class UserProfileView extends StatefulWidget {
  final String? userId; // If null, we are looking at "My Profile"
  const UserProfileView({this.userId, super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final GlobalKey _postsHeaderKey = GlobalKey();

  void _scrollToPosts() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final scrollContext = _postsHeaderKey.currentContext;
      if (scrollContext != null) {
        Scrollable.ensureVisible(
          scrollContext,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _checkUrlAndScroll() {
    final state = GoRouterState.of(context);
    if (state.uri.queryParameters['scrollTo'] == 'posts') {
      _scrollToPosts();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.userId == null) {
      context.read<ProfileCubit>().loadProfile(isRefresh: true);
      context.read<ProfilePostsCubit>().fetchAllProfileData();
    } else {
      context.read<GetUserProfileByIdCubit>().loadUserProfileById(
        widget.userId!,
      );
      context.read<GetUserPostsCubit>().fetchUserPosts(widget.userId!);

      WidgetsBinding.instance.addPostFrameCallback((_) => _checkUrlAndScroll());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMyProfile = widget.userId == null;

    if (isMyProfile) {
      return _buildMyProfileBody();
    } else {
      return _buildOtherUserProfileBody();
    }
  }

  Widget _buildMyProfileBody() {
    return VisibilityDetector(
      key: const Key('user-profile-visibility-key'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction == 1.0) {
          context.read<ProfileCubit>().loadProfile(isRefresh: true);
          context.read<ProfilePostsCubit>().fetchAllProfileData();
        }
      },
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) _checkUrlAndScroll();
        },
        builder: (context, profileState) {
          if (profileState is ProfileInitial ||
              profileState is ProfileLoading) {
            return _buildLoadingScaffold();
          }
          if (profileState is ProfileLoaded) {
            return _buildMainScaffold(profileState.user);
          }
          return const Scaffold(body: SizedBox.shrink());
        },
      ),
    );
  }

  Widget _buildOtherUserProfileBody() {
    return BlocBuilder<GetUserProfileByIdCubit, GetUserProfileByIdState>(
      builder: (context, state) {
        if (state is GetUserProfileByIdLoading) {
          return _buildLoadingScaffold();
        }
        if (state is GetUserProfileByIdLoaded) {
          return _buildMainScaffold(state.user);
        }
        if (state is GetUserProfileByIdError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }
        return const Scaffold(body: SizedBox.shrink());
      },
    );
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }

  Widget _buildMainScaffold(UserProfile user) {
    final l10n = AppLocalizations.of(context)!;
    final bool isMyProfile = widget.userId == null;

    return NotificationListener<ScrollToPostsNotification>(
      onNotification: (_) {
        _scrollToPosts();
        return true;
      },
      child: BlocBuilder<ProfilePostsCubit, ProfilePostsState>(
        builder: (context, postsState) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: false,
              surfaceTintColor: Colors.transparent,
              leading: !isMyProfile
                  ? IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Theme.of(context).iconTheme.color,
                        size: 25,
                      ),
                    )
                  : null,
              title: Text(
                'Trivio',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                if (isMyProfile)
                  IconButton(
                    onPressed: () => context.push(AppRoutes.profileSettings),
                    icon: Icon(
                      Icons.settings,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Divider(height: 1, color: Theme.of(context).cardColor),
              ),
            ),
            body: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                if (isMyProfile) {
                  await context.read<ProfilePostsCubit>().fetchAllProfileData();
                } else {
                  await context
                      .read<GetUserProfileByIdCubit>()
                      .loadUserProfileById(widget.userId!);
                  await context.read<GetUserPostsCubit>().fetchUserPosts(
                    widget.userId!,
                  );
                }
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
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Text(
                            l10n.posts,
                            key: _postsHeaderKey,
                            style: Styles.textStyle25.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  isMyProfile
                      ? _buildMyPostsList(user.id, l10n)
                      : _buildOtherUserPostsList(user.id, l10n),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMyPostsList(String currentUserId, dynamic l10n) {
    return BlocBuilder<ProfilePostsCubit, ProfilePostsState>(
      builder: (context, state) {
        if (state is ProfilePostsLoaded) {
          return _renderSliverList(state.myPosts, currentUserId, l10n);
        }
        return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildOtherUserPostsList(String profileId, dynamic l10n) {
    return BlocBuilder<GetUserPostsCubit, GetUserPostsState>(
      builder: (context, state) {
        if (state is GetUserPostsLoading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        if (state is GetUserPostsLoaded) {
          return _renderSliverList(state.posts, profileId, l10n);
        }
        if (state is GetUserPostsError) {
          return SliverToBoxAdapter(child: Center(child: Text(state.message)));
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _renderSliverList(List<Post> posts, String profileId, dynamic l10n) {
    final myState = context.read<ProfileCubit>().state;
    final postCubit = context
        .watch<PostCubit>();
    String myActualId = (myState is ProfileLoaded) ? myState.user.id : "";

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final localPost = posts[index];
        final post = postCubit.posts.firstWhere(
          (p) => p.postID == localPost.postID,
          orElse: () => localPost,
        );

        return PostCard(post: post, currentUserId: myActualId);
      }, childCount: posts.length),
    );
  }
}
