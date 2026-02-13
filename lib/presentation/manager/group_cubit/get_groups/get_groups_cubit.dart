import 'package:auth/domain/usecases/group/groups/get_groups_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAllGroupsCubit extends Cubit<GetGroupsState> {
  final GetAllGroupsUseCase getAllGroupsUseCase;

  GetAllGroupsCubit({required this.getAllGroupsUseCase})
    : super(GetGroupsInitial());

  Future<void> getAllGroups({int page = 1, String? search}) async {
    emit(GetGroupsLoading());
    final result = await getAllGroupsUseCase(page: page, search: search);

    result.fold(
      (failure) => emit(GetGroupsFailure(message: failure.message)),
      (groups) => emit(GetGroupsSuccess(groups: groups)),
    );
  }
}
