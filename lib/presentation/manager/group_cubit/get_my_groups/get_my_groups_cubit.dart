import 'package:auth/domain/usecases/group/groups/get_my_groups_use_case.dart';
import 'package:auth/presentation/manager/groups_pagination/base_pagination_cubit.dart';

import 'package:auth/domain/entities/group.dart';
import 'package:auth/presentation/manager/groups_pagination/pagination_state.dart';
import 'package:dartz/dartz.dart';

class GetMyGroupsCubit extends BasePaginationCubit<Group> {
  final GetMyGroupsUseCase getMyGroupsUseCase;
  String? currentSearch;

  GetMyGroupsCubit({required this.getMyGroupsUseCase});

  @override
  Future<Either<dynamic, List<Group>>> fetchUseCase({int page = 1}) {
    return getMyGroupsUseCase(page: page, search: currentSearch);
  }

  @override
  String getItemId(Group item) => item.groupId;

  Future<void> searchGroups(String query) {
    currentSearch = query;
    return loadData(refresh: true);
  }

  void removeGroupLocally(String groupId) {
    items.removeWhere((group) => group.groupId == groupId);
    emit(
      PaginationLoaded<Group>(
        items: List.from(items),
        hasReachedMax: hasReachedMax,
      ),
    );
  }
  void insertGroupLocally(Group newGroup) {
    final exists = items.any((group) => group.groupId == newGroup.groupId);

    if (!exists) {
      items.insert(0, newGroup);

      emit(
        PaginationLoaded<Group>(
          items: List.from(items),
          hasReachedMax: hasReachedMax,
        ),
      );
    }
  }
}
