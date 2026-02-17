import 'package:auth/domain/usecases/group/groups/get_joined_groups_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/get_joined_groups/get_joined_groups_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetJoinedGroupsCubit extends Cubit<GetJoinedGroupsState> {
  final GetJoinedGroupsUseCase getJoinedGroupsUseCase;

  GetJoinedGroupsCubit({required this.getJoinedGroupsUseCase})
    : super(GetJoinedGroupsInitial());

  Future<void> getJoinedGroups({int page = 1, String? search}) async {
    if (state is GetJoinedGroupsLoading) return;
    emit(GetJoinedGroupsLoading());

    final result = await getJoinedGroupsUseCase(page: page, search: search);

    result.fold(
      (failure) => emit(GetJoinedGroupsFailure(message: failure.message)),
      (groups) => emit(GetJoinedGroupsSuccess(groups: groups)),
    );
  }
}
