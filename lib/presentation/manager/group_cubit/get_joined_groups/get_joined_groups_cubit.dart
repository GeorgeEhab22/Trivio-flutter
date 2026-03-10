import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/usecases/group/groups/get_joined_groups_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'get_joined_groups_state.dart';

class GetJoinedGroupsCubit extends Cubit<GetJoinedGroupsState> {
  final GetJoinedGroupsUseCase getJoinedGroupsUseCase;

  GetJoinedGroupsCubit({required this.getJoinedGroupsUseCase})
    : super(GetJoinedGroupsInitial());

  List<Group> items = [];
  int page = 1;
  bool hasReachedMax = false;
  bool _isFetching = false;
  String? currentSearch;

  Future<void> loadData({bool refresh = false}) async {
    if (_isFetching ||
        state is GetJoinedGroupsLoading ||
        state is GetJoinedGroupsLoadingMore) {
      return;
    }
    _isFetching = true;

    if (refresh) {
      items.clear();
      page = 1;
      hasReachedMax = false;
    }

    if (items.isEmpty) {
      emit(GetJoinedGroupsLoading());
    } else {
      if (hasReachedMax) {
        _isFetching = false;
        return;
      }
      emit(GetJoinedGroupsLoadingMore(groups: List.from(items)));
    }

    final result = await getJoinedGroupsUseCase(
      page: page,
      search: currentSearch,
    );

    result.fold(
      (failure) {
        _isFetching = false;
        emit(
          GetJoinedGroupsError(
            message: failure.message,
            groups: List.from(items),
          ),
        );
      },
      (newItems) {
        if (isClosed) return;

        if (newItems.isEmpty) {
          hasReachedMax = true;
        } else {
          final existingIds = items.map((e) => e.groupId).toSet();
          final uniqueItems = newItems
              .where((e) => !existingIds.contains(e.groupId))
              .toList();

          if (uniqueItems.isEmpty) {
            hasReachedMax = true;
          } else {
            items.addAll(uniqueItems);
            page++;
          }
        }

        emit(
          GetJoinedGroupsLoaded(
            groups: List.from(items),
            hasReachedMax: hasReachedMax,
          ),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          _isFetching = false;
        });
      },
    );
  }

  Future<void> searchGroups(String query) {
    currentSearch = query;
    return loadData(refresh: true);
  }

  void insertGroupLocally(Group newGroup) {
    final exists = items.any((group) => group.groupId == newGroup.groupId);
    if (!exists) {
      items.insert(0, newGroup);
      emit(
        GetJoinedGroupsLoaded(
          groups: List.from(items),
          hasReachedMax: hasReachedMax,
        ),
      );
    }
  }

  void removeGroupLocally(String groupId) {
    items.removeWhere((group) => group.groupId == groupId);
    emit(
      GetJoinedGroupsLoaded(
        groups: List.from(items),
        hasReachedMax: hasReachedMax,
      ),
    );
  }
}
