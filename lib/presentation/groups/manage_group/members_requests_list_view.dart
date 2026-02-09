import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/group_cubit/accept_request/accept_request_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/accept_request/accept_request_state.dart';
import 'package:auth/presentation/manager/group_cubit/decline_request/decline_request_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/decline_request/decline_request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembersRequestsListView extends StatelessWidget {
  const MembersRequestsListView({super.key});

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
        body: ListView.builder(
          itemCount: 16,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage('https://picsum.photos/500'),
                ),
                title: const Padding(
                  padding: EdgeInsets.only(left: 2.0),
                  child: Text("Member name", style: Styles.textStyle16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showCustomDialog(
                          context: context,
                          title: "Accept this member?",
                          onConfirm: () {
                            context.read<AcceptRequestCubit>().acceptRequest(
                              groupId: "695d4782c3f2873f107b0f17",
                              requestId: "695d4b7cf2a6c38ff3657a76",
                            );
                          },
                          content:
                              "Are you sure you want to accept this member?",
                        );
                      },
                      icon: const Icon(Icons.check),
                    ),
                    IconButton(
                      onPressed: () {
                        showCustomDialog(
                          context: context,
                          title: "Decline this member?",
                          confirmText: "Decline",
                          confirmTextColor: Colors.red,
                          onConfirm: () {
                            context.read<DeclineRequestCubit>().declineRequest(
                              groupId: "695c2f8c9dae082566c285a8",
                              requestId: "695c2fdc9dae082566c285c8",
                            );
                          },
                          content:
                              "Are you sure you want to decline this member?",
                        );
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
