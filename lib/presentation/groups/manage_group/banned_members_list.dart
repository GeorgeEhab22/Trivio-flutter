import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/domain/entities/group_member.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/manager/group_cubit/get_banned_members/get_banned_members_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/unban_member/unban_member_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/unban_member/unban_member_state.dart';
import 'package:auth/presentation/manager/groups_pagination/pagination_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BannedMembersList extends StatelessWidget {
  final String groupId;
  const BannedMembersList({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<UnbanMemberCubit, UnbanMemberState>(
      listener: (context, state) {
        if (state is UnbanMemberSuccess) {
          showCustomSnackBar(context, state.message, true);
          //TODO : remove banned member locally

          // context.read<GetBannedMembersCubit>().removeMemberLocally(
          //   state.userId,
          // );
        }
        if (state is UnbanMemberFailure) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.bannedMembers)),
        body: BlocBuilder<GetBannedMembersCubit, PaginationState>(
          builder: (context, state) {
            final cubit = context.read<GetBannedMembersCubit>();

            if (state is PaginationError && cubit.items.isEmpty) {
              return Center(child: Text(state.message));
            }

            final bool isInitialLoading =
                state is PaginationLoading && cubit.items.isEmpty;
            final bool isLoadingMore = state is PaginationLoadingMore;

            final List<GroupMember> displayBanned = isInitialLoading
                ? DummyData.dummyMembers
                : [...cubit.items, if (isLoadingMore) DummyData.dummyMember];

            if (state is PaginationLoaded && cubit.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person_search_rounded,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noPendingRequests,
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo is ScrollUpdateNotification &&
                    (scrollInfo.scrollDelta ?? 0) > 0 &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent * 0.8) {
                  cubit.loadData();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: displayBanned.length + (cubit.hasReachedMax ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == displayBanned.length) {
                    return const SizedBox(height: 50);
                  }

                  final bannedMember = displayBanned[index];

                  return Skeletonizer(
                    enabled: isInitialLoading || bannedMember.userId.isEmpty,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundImage: NetworkImage(
                          bannedMember.profileImageUrl ??
                              'https://picsum.photos/500',
                        ),
                      ),
                      title: Text(
                        bannedMember.userName,
                        style: Styles.textStyle16,
                      ),
                      trailing: Icon(
                        Icons.more_horiz,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onTap: isInitialLoading || bannedMember.userId.isEmpty
                          ? null
                          : () {
                              showCustomDialog(
                                context: context,
                                confirmText: l10n.unban,
                                confirmTextColor: Colors.red,
                                onConfirm: () {
                                  context.read<UnbanMemberCubit>().unbanMember(
                                    groupId: groupId,
                                    targetUserId: bannedMember.userId,
                                  );
                                },
                                title: l10n.unbanUserTitle(bannedMember.userName),
                                content: l10n.unbanUserContent(bannedMember.userName),
                              );
                            },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
