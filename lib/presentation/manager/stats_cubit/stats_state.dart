part of 'stats_cubit.dart';

sealed class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object> get props => [];
}

final class StatsInitial extends StatsState {}
final class StatsLoading extends StatsState {}
final class StatsLoaded extends StatsState {
  final List<Matches> matches;  // List of Match objects

  StatsLoaded({required this.matches});
}
final class StatsError extends StatsState {
  final String message;

  StatsError({required this.message});
}