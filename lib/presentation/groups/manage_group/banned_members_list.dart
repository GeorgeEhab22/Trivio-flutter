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

    // return MultiBlocListener(
    //   listeners: [
    //     BlocListener<UnbanMemberCubit, UnbanMemberState>(
    //       listener: (context, state) {
    //         if (state is UnbanMemberSuccess) {
    //           showCustomSnackBar(context, l10n.unbanSuccess, true);
              
    //           context.read<GetBannedMembersCubit>().getBannedMembers(
    //                 groupId: groupId,
    //               );
    //         }
    //         if (state is UnbanMemberFailure) {
    //           showCustomSnackBar(context, l10n.unexpected_error, false);
    //         }
    //       },
    //     ),
    //   ],
    //   child: Scaffold(
    //     appBar: AppBar(title: Text(l10n.bannedMembers)),
    //     body: BlocBuilder<GetBannedMembersCubit, PaginationState>(
    //       builder: (context, state) {
    //         final cubit = context.read<GetBannedMembersCubit>();

    //         if (state is PaginationError && cubit.items.isEmpty) {
    //           return Center(child: Text(state.message));
    //         }

    //         if (state is GetBannedMembersSuccess) {
    //           if (state.bannedMembers.isEmpty) {
    //             return Center(child: Text(l10n.noBannedMembers));
    //           }
    //           return ListView.builder(
    //             itemCount: state.bannedMembers.length,
    //             itemBuilder: (context, index) {
    //               final bannedMember = state.bannedMembers[index];
    //               final userName = bannedMember.userName ?? l10n.username;

    //               return ListTile(
    //                 leading: CircleAvatar(
    //                   radius: 26,
    //                   backgroundImage: NetworkImage(
    //                     bannedMember.profileImageUrl ?? 'https://picsum.photos/500',
    //                   ),
    //                 ),
    //                 title: Text(userName, style: Styles.textStyle16),
    //                 trailing: Icon(
    //                   Icons.more_horiz,
    //                   color: Theme.of(context).iconTheme.color,
    //                 ),
    //                 onTap: () {
    //                   showCustomDialog(
    //                     context: context,
    //                     confirmText: l10n.unban,
    //                     confirmTextColor: Colors.red,
    //                     onConfirm: () {
    //                       context.read<UnbanMemberCubit>().unbanMember(
    //                             groupId: groupId,
    //                             targetUserId: bannedMember.userId!,
    //                           );
    //                     },
    //                     title: l10n.unbanUserTitle(userName),
    //                     content: l10n.unbanUserContent(userName),
    //                   );
    //                 },
    //               );
    //             },
    //           );
    //         }
    //         if (state is GetBannedMembersFailure) {
    //           return Center(child: Text(state.message));
    //         }

            return const SizedBox();
    //      },
    //    ),
    //  ),
    // );
  }
}
