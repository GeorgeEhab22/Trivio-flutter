import 'package:auth/domain/usecases/group/groups/get_groups_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAllGroupsCubit extends Cubit<GetGroupsState> {
  final GetAllGroupsUseCase getAllGroupsUseCase;

  GetAllGroupsCubit({required this.getAllGroupsUseCase})
    : super(GetGroupsInitial());

  Future<void> getAllGroups({int page = 1, String? search}) async {
    if (state is GetGroupsLoading) return;
    emit(GetGroupsLoading());
    final result = await getAllGroupsUseCase(page: page, search: search);

    result.fold(
      (failure) => emit(GetGroupsFailure(message: failure.message)),
      (groups) => emit(GetGroupsSuccess(groups: groups)),
    );
  }

  void removeGroupLocally(String groupId) {
    if (state is GetGroupsSuccess) {
      final currentState = state as GetGroupsSuccess;
      
      final updatedList = currentState.groups
          .where((group) => group.groupId != groupId)
          .toList();
      
      emit(GetGroupsSuccess(groups: updatedList));
    }
  }
}
