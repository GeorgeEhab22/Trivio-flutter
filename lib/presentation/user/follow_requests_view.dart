import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/domain/entities/follow_request.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_request_cubit.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_request_state.dart';
import 'package:auth/presentation/user/widgets/follow_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowRequestsView extends StatelessWidget {
  FollowRequestsView({super.key});

  // Extremely lightweight notifier to handle the local UI list
  final ValueNotifier<List<FollowRequest>> requestsNotifier = ValueNotifier([]);
  
  // Track the ID being handled without a StatefulWidget
  String lastHandledId = '';

  @override
  Widget build(BuildContext context) {
    // Trigger initial fetch
    context.read<FollowRequestCubit>().getMyFollowRequests();

    return Scaffold(
      appBar: AppBar(
        title: Text("Follow Requests", style: Styles.textStyle30),
        shape: Border(bottom: BorderSide(color: AppColors.lightGrey, width: 2)),
      ),
      body: BlocListener<FollowRequestCubit, FollowRequestState>(
        listener: (context, state) {
          if (state is FollowRequestLoaded) {
            // Sync the notifier with the loaded data
            requestsNotifier.value = List.from(state.requests);
          } 
          
          if (state is FollowRequestActionSuccess) {
            showCustomSnackBar(context, state.message, true);
            // Remove from the notifier list immediately
            requestsNotifier.value = requestsNotifier.value
                .where((req) => req.id != lastHandledId)
                .toList();
          }

          if (state is FollowRequestFailure) {
            showCustomSnackBar(context, state.message, false);
          }
        },
        child: ValueListenableBuilder<List<FollowRequest>>(
          valueListenable: requestsNotifier,
          builder: (context, currentRequests, _) {
            // Handle Empty State
            if (currentRequests.isEmpty) {
              return Center(
                child: Text(
                  "No follow requests yet.",
                  style: Styles.textStyle20.copyWith(color: AppColors.primary),
                ),
              );
            }

            return ListView.builder(
              itemCount: currentRequests.length,
              itemBuilder: (context, index) {
                final request = currentRequests[index];
                return FollowRequestCard(
                  key: ValueKey(request.id),
                  follower: request.follower,
                  onAccept: () {
                    lastHandledId = request.id;
                    context.read<FollowRequestCubit>().acceptRequest(request.id);
                  },
                  onDecline: () {
                    lastHandledId = request.id;
                    context.read<FollowRequestCubit>().declineRequest(request.id);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}