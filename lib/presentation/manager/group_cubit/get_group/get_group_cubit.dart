import 'package:auth/domain/usecases/group/groups/get_group_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetGroupCubit extends Cubit<GetGroupState> {
  final GetGroupUseCase getGroupUseCase;

  GetGroupCubit({required this.getGroupUseCase}) : super(GetGroupInitial());

  Future<void> getGroup(String groupId) async {
    emit(GetGroupLoading());
    final result = await getGroupUseCase(groupId: groupId);

    result.fold(
      (failure) => emit(GetGroupFailure(message: failure.message)),
      (group) => emit(GetGroupSuccess(group: group)),
    );
  }
}
