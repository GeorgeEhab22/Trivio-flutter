import 'package:auth/domain/usecases/group/groups/get_my_groups_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/get_my_groups/get_my_groups_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMyGroupsCubit extends Cubit<GetMyGroupsState> {
  final GetMyGroupsUseCase getMyGroupsUseCase;

  GetMyGroupsCubit({required this.getMyGroupsUseCase})
      : super(GetMyGroupsInitial());

  Future<void> getMyGroups({int page = 1, String? search}) async {
    if (state is GetMyGroupsLoading) return;
    emit(GetMyGroupsLoading());

    final result = await getMyGroupsUseCase(page: page, search: search);

    result.fold(
      (failure) => emit(GetMyGroupsFailure(message: failure.message)),
      (groups) => emit(GetMyGroupsSuccess(groups: groups)),
    );
  }
   void removeGroupLocally(String groupId) {
    if (state is GetMyGroupsSuccess) {
      final currentState = state as GetMyGroupsSuccess;
      
      final updatedList = currentState.groups
          .where((group) => group.groupId != groupId)
          .toList();
      
      emit(GetMyGroupsSuccess(groups: updatedList));
    }
  }
}