import 'package:equatable/equatable.dart';

abstract class PaginationState<T> extends Equatable {
  const PaginationState();

  @override
  List<Object?> get props => [];
}

class PaginationInitial<T> extends PaginationState<T> {}

class PaginationLoading<T> extends PaginationState<T> {}

class PaginationLoaded<T> extends PaginationState<T> {
  final List<T> items;
  final bool hasReachedMax;

  const PaginationLoaded({required this.items, this.hasReachedMax = false});

  @override
  List<Object?> get props => [items, hasReachedMax];
}

class PaginationLoadingMore<T> extends PaginationState<T> {
  final List<T> items;
  const PaginationLoadingMore({required this.items});

  @override
  List<Object?> get props => [items];
}

class PaginationError<T> extends PaginationState<T> {
  final String message;
  final List<T> items;

  const PaginationError({required this.message, this.items = const []});

  @override
  List<Object?> get props => [message, items];
}
