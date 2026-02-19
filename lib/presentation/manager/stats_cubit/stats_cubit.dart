import 'package:auth/data/models/stats_dart/matches.dart';
import 'package:auth/domain/usecases/stats/stats_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final StatsUseCase statsUseCase;
  StatsCubit(this.statsUseCase) : super(StatsInitial());

  Future<void> loadStats() async {
    if (isClosed) return;

    emit(StatsLoading());

    try {
      final result = await statsUseCase.call();

      if (isClosed) return;

      result.fold(
        (failure) => emit(StatsError(message: failure.message)),
        (matches) => emit(StatsLoaded(matches: matches)),
      );
    } catch (e) {
      if (isClosed) return;
      emit(const StatsError(message: "failed_to_load"));
    }
  }
}