import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/group_cubit/accept_request/accept_request_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/accept_request/accept_request_state.dart';
import 'package:auth/presentation/manager/group_cubit/decline_request/decline_request_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/decline_request/decline_request_state.dart';
import 'package:auth/presentation/manager/group_cubit/get_join_requests/get_join_requests_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_join_requests/get_join_requests_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembersRequestsListView extends StatelessWidget {
  final String groupId;
  const MembersRequestsListView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AcceptRequestCubit, AcceptRequestState>(
          listener: (context, state) {
            if (state is AcceptRequestSuccess) {
              showCustomSnackBar(
                context,
                "Request accepted successfully",
                true,
              );
            }
            if (state is AcceptRequestFailure) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
        BlocListener<DeclineRequestCubit, DeclineRequestState>(
          listener: (context, state) {
            if (state is DeclineRequestSuccess) {
              showCustomSnackBar(
                context,
                "Request declined successfully",
                true,
              );
            }
            if (state is DeclineRequestFailure) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Members requests')),
        body: BlocBuilder<GetJoinRequestsCubit, GetJoinRequestsState>(
          builder: (context, state) {
            if (state is GetJoinRequestsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetJoinRequestsEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_search_rounded,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "No pending requests",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              );
            } else if (state is GetJoinRequestsSuccess) {
              final requests = state.requests;
              return ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 26,
                        backgroundImage: NetworkImage(
                          'https://picsum.photos/500',
                        ), //
                      ),
                      title: Text(
                        request.userName,
                        style: Styles.textStyle16,
                      ), //
                      subtitle: Text(request.userEmail),
                      trailing: Builder(
                        builder: (context) {
                          final acceptState = context
                              .watch<AcceptRequestCubit>()
                              .state;
                          final declineState = context
                              .watch<DeclineRequestCubit>()
                              .state;

                          if (acceptState is AcceptRequestSuccess &&
                              acceptState.requestId == request.requestId) {
                            return const Text("Accepted");
                          }

                          if (declineState is DeclineRequestSuccess &&
                              declineState.requestId == request.requestId) {
                            return const Text("Declined");
                          }

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () => showCustomDialog(
                                  context: context,
                                  title: "Accept this member?",
                                  onConfirm: () {
                                    context
                                        .read<AcceptRequestCubit>()
                                        .acceptRequest(
                                          groupId: groupId,
                                          requestId: request.requestId,
                                        );
                                  },
                                  content:
                                      "Do you want to add ${request.userName} to the group?",
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => showCustomDialog(
                                  context: context,
                                  title: "Decline request?",
                                  confirmText: "Decline",
                                  confirmTextColor: Colors.red,
                                  onConfirm: () {
                                    context
                                        .read<DeclineRequestCubit>()
                                        .declineRequest(
                                          groupId: groupId,
                                          requestId: request.requestId,
                                        );
                                  },
                                  content:
                                      "Are you sure you want to decline this request?",
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (state is GetJoinRequestsFailure) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
