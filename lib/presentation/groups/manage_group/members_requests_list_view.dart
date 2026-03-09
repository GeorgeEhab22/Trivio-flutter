import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/core/errors/error_parser.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/domain/entities/join_request.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/manager/group_cubit/accept_request/accept_request_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/accept_request/accept_request_state.dart';
import 'package:auth/presentation/manager/group_cubit/decline_request/decline_request_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/decline_request/decline_request_state.dart';
import 'package:auth/presentation/manager/group_cubit/get_join_requests/get_join_requests_cubit.dart';
import 'package:auth/presentation/manager/groups_pagination/pagination_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
              context.read<GetJoinRequestsCubit>().removeRequestLocally(
                state.requestId,
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
              showCustomSnackBar(context, l10n.requestDeclinedSuccess, true);
              context.read<GetJoinRequestsCubit>().removeRequestLocally(
                state.requestId,
              );
            }
            if (state is DeclineRequestFailure) {
              final errorMessage = ErrorParser.localizeError(
                context,
                state.message,
              );
              showCustomSnackBar(context, errorMessage, false);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.membersRequests)),
        body: BlocBuilder<GetJoinRequestsCubit, PaginationState>(
          builder: (context, state) {
            final cubit = context.read<GetJoinRequestsCubit>();

            if (state is PaginationError && cubit.items.isEmpty) {
              return Center(child: Text(state.message));
            }

            final bool isInitialLoading =
                state is PaginationLoading && cubit.items.isEmpty;
            final bool isLoadingMore = state is PaginationLoadingMore;

            final List<JoinRequest> displayRequests = isInitialLoading
                ? DummyData.dummyRequests
                : [...cubit.items, if (isLoadingMore) DummyData.dummyRequest];

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
                itemCount:
                    displayRequests.length + (cubit.hasReachedMax ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == displayRequests.length) {
                    return const SizedBox(height: 50);
                  }

                  final request = displayRequests[index];

                  return Skeletonizer(
                    enabled: isInitialLoading || request.requestId.isEmpty,
                    child: Padding(
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check),
                              onPressed:
                                  isInitialLoading || request.requestId.isEmpty
                                  ? null
                                  : () => showCustomDialog(
                                      context: context,
                                      title: l10n.acceptMemberTitle,
                                      onConfirm: () => context
                                          .read<AcceptRequestCubit>()
                                          .acceptRequest(
                                            groupId: groupId,
                                            requestId: request.requestId,
                                          ),
                                      content: l10n.acceptMemberContent(
                                        request.userName,
                                      ),
                                    ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed:
                                  isInitialLoading || request.requestId.isEmpty
                                  ? null
                                  : () => showCustomDialog(
                                      context: context,
                                      title: l10n.declineRequestTitle,
                                      confirmText: l10n.decline,
                                      confirmTextColor: Colors.red,
                                      onConfirm: () => context
                                          .read<DeclineRequestCubit>()
                                          .declineRequest(
                                            groupId: groupId,
                                            requestId: request.requestId,
                                          ),
                                      content: l10n.declineRequestContent,
                                    ),
                            ),
                          ],
                        ),
                      ),
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
