import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/manager/follow_cubit/get_follow_info_cubit.dart';
import 'package:auth/presentation/manager/follow_cubit/get_follow_info_state.dart';
import 'package:auth/presentation/user/widgets/follow_info_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowingListView extends StatelessWidget {
  final String? userId;
  const FollowingListView({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FollowInfoCubit>();
    
    // Initial Fetch
    /* original:
    cubit.getMyFollowing();
    */
    if (userId == null) {
      cubit.getMyFollowing();
    } else {
      cubit.getUserFollowing(userId!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Following", style: Styles.textStyle30),
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
              isFollowingList: true, // In following list, display 'userId'
              hasReachedMax: state.hasReachedMax,
              onLoadMore: userId == null 
                ? () => cubit.getMyFollowing(loadMore: true) 
                : null,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}