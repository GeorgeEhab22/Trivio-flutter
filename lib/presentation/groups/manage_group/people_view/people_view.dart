import 'package:auth/injection_container.dart' as di;
import 'package:auth/presentation/groups/manage_group/admins_list_view.dart';
import 'package:auth/presentation/groups/manage_group/members_list_view.dart';
import 'package:auth/presentation/groups/manage_group/moderators_list_view.dart';
import 'package:auth/presentation/groups/manage_group/people_view/widgets/people_app_bar.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_state.dart';
import 'package:auth/presentation/manager/group_cubit/get_user_group_role/user_group_role_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_user_group_role/user_group_role_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PeopleView extends StatelessWidget {
  final String groupId;
  const PeopleView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<UserGroupRoleCubit>()..getUserRole(groupId),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: const PeopleAppBar(),
          body: Builder(
            builder: (context) {
              return BlocBuilder<UserGroupRoleCubit, UserGroupRoleState>(
                builder: (context, state) {
                  String myRoleInGroup = 'member';
                  if (state is UserGroupRoleSuccess) {
                    myRoleInGroup = state.role;
                  }
                  final profileState = context.read<ProfileCubit>().state;
                  final groupState = context.read<GetGroupCubit>().state;

                  if (profileState is ProfileLoaded &&
                      groupState is GetGroupSuccess) {
                    if (profileState.user.id == groupState.group.creatorId) {
                      myRoleInGroup = 'creator';
                    }
                  }
                  return TabBarView(
                    children: [
                      MembersListView(
                        key: const PageStorageKey('members'),
                        groupId: groupId,
                        myRole: myRoleInGroup,
                      ),
                      ModeratorsListView(
                        key: const PageStorageKey('moderators'),
                        groupId: groupId,
                        myRole: myRoleInGroup,
                      ),
                      AdminsListView(
                        key: const PageStorageKey('admins'),
                        groupId: groupId,
                        myRole: myRoleInGroup,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
