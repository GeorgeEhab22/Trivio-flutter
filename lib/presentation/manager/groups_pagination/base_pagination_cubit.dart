import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pagination_state.dart';

abstract class BasePaginationCubit<T> extends Cubit<PaginationState<T>> {
  BasePaginationCubit() : super(PaginationInitial<T>());

  List<T> items = [];
  int page = 1;
  bool hasReachedMax = false;
  bool _isFetching = false;

  Future<Either<dynamic, List<T>>> fetchUseCase({int page});

  String getItemId(T item);

  Future<void> loadData({bool refresh = false}) async {
    if (_isFetching ||
        state is PaginationLoading<T> ||
        state is PaginationLoadingMore<T>) {
      return;
    }
    _isFetching = true;

    if (refresh) {
      items.clear();
      page = 1;
      hasReachedMax = false;
    }

    if (items.isEmpty) {
      emit(PaginationLoading<T>());
    } else {
      if (hasReachedMax) {
        _isFetching = false;
        return;
      }
      emit(PaginationLoadingMore<T>(items: List.from(items)));
    }

    final result = await fetchUseCase(page: page);

    result.fold(
      (failure) {
        _isFetching = false;
        emit(
          PaginationError<T>(message: failure.message, items: List.from(items)),
        );
      },
      (newItems) {
        if (isClosed) return;

        if (newItems.isEmpty) {
          hasReachedMax = true;
        } else {
          final existingIds = items.map((e) => getItemId(e)).toSet();
          final uniqueItems = newItems
              .where((e) => !existingIds.contains(getItemId(e)))
              .toList();

          if (uniqueItems.isEmpty) {
            hasReachedMax = true;
          } else {
            items.addAll(uniqueItems);
            page++;
          }
        }

        emit(
          PaginationLoaded<T>(
            items: List.from(items),
            hasReachedMax: hasReachedMax,
          ),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          _isFetching = false;
        });
      },
    );
  }
}
