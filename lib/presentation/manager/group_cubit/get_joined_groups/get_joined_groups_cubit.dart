import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/usecases/group/groups/get_joined_groups_use_case.dart';
import 'package:auth/presentation/manager/groups_pagination/base_pagination_cubit.dart';
import 'package:auth/presentation/manager/groups_pagination/pagination_state.dart';
import 'package:dartz/dartz.dart';

class GetJoinedGroupsCubit extends BasePaginationCubit<Group> {
  final GetJoinedGroupsUseCase getJoinedGroupsUseCase;
  String? currentSearch;

  GetJoinedGroupsCubit({required this.getJoinedGroupsUseCase});

  @override
  Future<Either<dynamic, List<Group>>> fetchUseCase({int page = 1}) {
    return getJoinedGroupsUseCase(page: page, search: currentSearch);
  }

  @override
  String getItemId(Group item) => item.groupId;

  Future<void> searchGroups(String query) {
    currentSearch = query;
    return loadData(refresh: true);
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
  void removeGroupLocally(String groupId) {
    items.removeWhere((group) => group.groupId == groupId);
    emit(
      PaginationLoaded<Group>(
        items: List.from(items),
        hasReachedMax: hasReachedMax,
      ),
    );
  }
}
