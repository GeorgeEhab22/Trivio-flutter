import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/usecases/group/groups/get_groups_use_case.dart';
import 'package:auth/presentation/manager/groups_pagination/base_pagination_cubit.dart';
import 'package:auth/presentation/manager/groups_pagination/pagination_state.dart';
import 'package:dartz/dartz.dart';

class GetAllGroupsCubit extends BasePaginationCubit<Group> {
  final GetAllGroupsUseCase getAllGroupsUseCase;
  String? currentSearch;

  GetAllGroupsCubit({required this.getAllGroupsUseCase});

  @override
  Future<Either<dynamic, List<Group>>> fetchUseCase({int page = 1}) {
    return getAllGroupsUseCase(page: page, search: currentSearch);
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
}
