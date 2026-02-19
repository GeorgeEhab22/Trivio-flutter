import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<AcceptRequestCubit, AcceptRequestState>(
          listener: (context, state) {
            if (state is AcceptRequestSuccess) {
              showCustomSnackBar(context, l10n.requestAcceptedSuccess, true);
            }
            if (state is AcceptRequestFailure) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
        BlocListener<DeclineRequestCubit, DeclineRequestState>(
          listener: (context, state) {
            if (state is DeclineRequestSuccess) {
              showCustomSnackBar(context, l10n.requestDeclinedSuccess, true);
            }
            if (state is DeclineRequestFailure) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.membersRequests)),
        body: BlocBuilder<GetJoinRequestsCubit, GetJoinRequestsState>(
          builder: (context, state) {
            if (state is GetJoinRequestsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetJoinRequestsEmpty) {
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
                        ),
                      ),
                      title: Text(
                        request.userName.isEmpty
                            ? l10n.unknownUser
                            : request.userName,
                        style: Styles.textStyle16,
                      ),
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
                            return Text(l10n.accepted);
                          }

                          if (declineState is DeclineRequestSuccess &&
                              declineState.requestId == request.requestId) {
                            return Text(l10n.declined);
                          }

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () => showCustomDialog(
                                  context: context,
                                  title: l10n.acceptMemberTitle,
                                  onConfirm: () {
                                    context
                                        .read<AcceptRequestCubit>()
                                        .acceptRequest(
                                          groupId: groupId,
                                          requestId: request.requestId,
                                        );
                                  },
                                  content: l10n.acceptMemberContent(
                                    request.userName,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => showCustomDialog(
                                  context: context,
                                  title: l10n.declineRequestTitle,
                                  confirmText: l10n.decline,
                                  confirmTextColor: Colors.red,
                                  onConfirm: () {
                                    context
                                        .read<DeclineRequestCubit>()
                                        .declineRequest(
                                          groupId: groupId,
                                          requestId: request.requestId,
                                        );
                                  },
                                  content: l10n.declineRequestContent,
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
