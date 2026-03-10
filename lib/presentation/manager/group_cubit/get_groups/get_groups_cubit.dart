import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/usecases/group/groups/get_groups_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAllGroupsCubit extends Cubit<GetAllGroupsState> {
  final GetAllGroupsUseCase getAllGroupsUseCase;

  GetAllGroupsCubit({required this.getAllGroupsUseCase})
    : super(GetAllGroupsInitial());

  List<Group> items = [];
  int page = 1;
  bool hasReachedMax = false;
  bool _isFetching = false;
  String? currentSearch;

  Future<void> loadData({bool refresh = false}) async {
    if (_isFetching ||
        state is GetAllGroupsLoading ||
        state is GetAllGroupsLoadingMore) {
      return;
    }
    _isFetching = true;

    if (refresh) {
      items.clear();
      page = 1;
      hasReachedMax = false;
    }

    if (items.isEmpty) {
      emit(GetAllGroupsLoading());
    } else {
      if (hasReachedMax) {
        _isFetching = false;
        return;
      }
      emit(GetAllGroupsLoadingMore(groups: List.from(items)));
    }

    final result = await getAllGroupsUseCase(page: page, search: currentSearch);

    result.fold(
      (failure) {
        _isFetching = false;
        emit(
          GetAllGroupsError(message: failure.message, groups: List.from(items)),
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
          GetAllGroupsLoaded(
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
      GetAllGroupsLoaded(
        groups: List.from(items),
        hasReachedMax: hasReachedMax,
      ),
    );
  }

  void insertGroupLocally(Group newGroup) {
    final exists = items.any((group) => group.groupId == newGroup.groupId);
    if (!exists) {
      items.insert(0, newGroup);
      emit(
        GetAllGroupsLoaded(
          groups: List.from(items),
          hasReachedMax: hasReachedMax,
        ),
      );
    }
  }
}
