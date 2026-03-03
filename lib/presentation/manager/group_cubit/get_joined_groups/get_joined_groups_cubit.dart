import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/usecases/group/groups/get_joined_groups_use_case.dart';
import 'package:auth/presentation/manager/groups_pagination/base_pagination_cubit.dart';
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
}
