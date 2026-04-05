import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_card.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_posts_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_posts_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/user/widgets/profile_info_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScrollToPostsNotification extends Notification {}

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

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
    context.read<ProfileCubit>().loadProfile(isRefresh: true);
    context.read<ProfilePostsCubit>().fetchAllProfileData();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkUrlAndScroll());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            return Scaffold(
              body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            );
          }

          if (profileState is ProfileLoaded) {
            final user = profileState.user;

            return NotificationListener<ScrollToPostsNotification>(
              onNotification: (_) {
                _scrollToPosts();
                return true;
              },
              child: BlocBuilder<ProfilePostsCubit, ProfilePostsState>(
                builder: (context, postsState) {
                  return Scaffold(
                    backgroundColor:Theme.of(context).scaffoldBackgroundColor,
                    appBar: AppBar(
                      backgroundColor:Theme.of(context).appBarTheme.backgroundColor,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      centerTitle: false,
                      surfaceTintColor: Colors.transparent,
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
                        IconButton(
                          onPressed: () =>
                              context.push(AppRoutes.profileSettings),
                          icon:  Icon(Icons.settings,color: Theme.of(context).iconTheme.color,),
                        ),
                      ],
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(1),
                        child: Divider(height: 1, color:Theme.of(context).cardColor),
                      ),
                    ),
                    body: RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async => context
                          .read<ProfilePostsCubit>()
                          .fetchAllProfileData(),
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
                          if (postsState is ProfilePostsLoaded)
                            postsState.myPosts.isEmpty
                                ? SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Center(child: Text(l10n.noPostsYet)),
                                  )
                                : SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) => PostCard(
                                        post: postsState.myPosts[index],
                                        currentUserId: user.id,
                                      ),
                                      childCount: postsState.myPosts.length,
                                    ),
                                  )
                          else
                            const SliverToBoxAdapter(child: SizedBox.shrink()),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Scaffold(body: SizedBox.shrink());
        },
      ),
    );
  }
}
