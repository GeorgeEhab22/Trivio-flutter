import 'package:auth/domain/entities/join_request.dart';
import 'package:auth/domain/usecases/group/groups/join_group_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/join_group/join_group_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//TODO: remove the serverConfirmedRequests when backend returns the status
class JoinGroupCubit extends Cubit<JoinGroupState> {
  final JoinGroupUseCase _joinGroupUseCase;

  JoinGroupCubit({required JoinGroupUseCase joinGroupUseCase})
    : _joinGroupUseCase = joinGroupUseCase,
      super(const JoinGroupInitial(serverConfirmedRequests: {}));

  void initServerRequests(List<JoinRequest> serverRequests) {
    final Map<String, String> requestsMap = {};
    for (var req in serverRequests) {
      requestsMap[req.groupId] = req.status;
    }
    emit(JoinGroupInitial(serverConfirmedRequests: requestsMap));
  }

  Future<void> joinGroup({required String groupId}) async {
    emit(
      JoinGroupLoading(
        loadingGroupId: groupId,
        serverConfirmedRequests: state.serverConfirmedRequests,
      ),
    );

    final result = await _joinGroupUseCase(groupId: groupId);

    result.fold(
      (failure) {
        emit(
          JoinGroupFailure(
            message: failure.message,
            errorType: 'server_error',
            serverConfirmedRequests: state.serverConfirmedRequests,
          ),
        );
      },
      (successMessage) {
        final updatedRequests = Map<String, String>.from(
          state.serverConfirmedRequests,
        );
        updatedRequests[groupId] = 'pending';

        emit(JoinGroupSuccess(serverConfirmedRequests: updatedRequests));
      },
    );
  }
  void removeRequestLocally(String groupId) {
    final updatedRequests = Map<String, String>.from(state.serverConfirmedRequests);
    
    updatedRequests.remove(groupId); 
    
    emit(JoinGroupInitial(serverConfirmedRequests: updatedRequests));
  }
}
