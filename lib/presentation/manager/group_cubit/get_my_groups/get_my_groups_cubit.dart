import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/usecases/group/groups/get_my_groups_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'get_my_groups_state.dart';

class GetMyGroupsCubit extends Cubit<GetMyGroupsState> {
  final GetMyGroupsUseCase getMyGroupsUseCase;

  GetMyGroupsCubit({required this.getMyGroupsUseCase})
    : super(GetMyGroupsInitial());

  List<Group> items = [];
  int page = 1;
  bool hasReachedMax = false;
  bool _isFetching = false;
  String? currentSearch;

  Future<void> loadData({bool refresh = false}) async {
    if (_isFetching ||
        state is GetMyGroupsLoading ||
        state is GetMyGroupsLoadingMore) {
      return;
    }
    _isFetching = true;

    if (refresh) {
      items.clear();
      page = 1;
      hasReachedMax = false;
    }

    if (items.isEmpty) {
      emit(GetMyGroupsLoading());
    } else {
      if (hasReachedMax) {
        _isFetching = false;
        return;
      }
      emit(GetMyGroupsLoadingMore(groups: List.from(items)));
    }

    final result = await getMyGroupsUseCase(page: page, search: currentSearch);

    result.fold(
      (failure) {
        _isFetching = false;
        emit(
          GetMyGroupsError(message: failure.message, groups: List.from(items)),
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
          GetMyGroupsLoaded(
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

  void removeGroupLocally(String groupId) {
    items.removeWhere((group) => group.groupId == groupId);
    emit(
      GetMyGroupsLoaded(groups: List.from(items), hasReachedMax: hasReachedMax),
    );
  }

  void insertGroupLocally(Group newGroup) {
    final exists = items.any((group) => group.groupId == newGroup.groupId);
    if (!exists) {
      items.insert(0, newGroup);
      emit(
        GetMyGroupsLoaded(
          groups: List.from(items),
          hasReachedMax: hasReachedMax,
        ),
      );
    }
  }
}
