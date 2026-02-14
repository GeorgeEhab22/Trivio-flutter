import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/manager/follow_cubit/get_follow_info_cubit.dart';
import 'package:auth/presentation/manager/follow_cubit/get_follow_info_state.dart';
import 'package:auth/presentation/user/widgets/follow_info_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowersListView extends StatelessWidget {
  final String? userId;
  const FollowersListView({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FollowInfoCubit>();
    
    // Initial Fetch
    /* original:
    cubit.getMyFollowers();
    */
    if (userId == null) {
      cubit.getMyFollowers();
    } else {
      cubit.getUserFollowers(userId!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Followers", style: Styles.textStyle30),
        shape: Border(bottom: BorderSide(color: AppColors.lightGrey, width: 2)),
      ),
      body: BlocBuilder<FollowInfoCubit, FollowInfoState>(
        builder: (context, state) {
          if (state is FollowInfoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FollowInfoLoaded) {
            return FollowInfoList(
              data: state.data,
              isFollowingList: false, // In followers list, display 'followerId'
              hasReachedMax: state.hasReachedMax,
              onLoadMore: userId == null 
                ? () => cubit.getMyFollowers(loadMore: true) 
                : null,
            );
          }

          if (state is FollowInfoFailure) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}